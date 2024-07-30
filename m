Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A861BBBDB;
	Tue, 30 Jul 2024 15:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355137; cv=none; b=dw7Z7iOzs4ynkds+Z32kEkiRMXqq2y7DiUS61RgFxfWNO5JZEDRK4mYJgtzKrhcbiUZF1Eb2Ij7dXrzsW+wmh+jQAzkHYzVZSmEVDX9ZkcexrMAl6hTL6H9s8M+Uf9KOvf4rm8hRSRe2M6Yi1OqFSnzOc77oML7vlEkrg9vOYsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355137; c=relaxed/simple;
	bh=XZO8+rmxhrPgV9C0P3dhw7fSwois28EmHLO/hYttW/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLxmf03jLlCjiMYI7Eeowi1dkPt9ze7r0HZXi7MMBMRVNydKeAMG4p7WVEapuC6uRumyBPxDSmGtRFHsTGJ/pKQD79gNdyMAYkyNmyNR9x2gm6ayW14KexBA9KfRJqYqxcx5ydI62fIGJwLNHei+xOLAhkvG6CkVJ+/tp8xbkyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VaRCwBvQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VaRCwBvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3C3C32782;
	Tue, 30 Jul 2024 15:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355136;
	bh=XZO8+rmxhrPgV9C0P3dhw7fSwois28EmHLO/hYttW/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaRCwBvQWdgthR0hxjuaBpbbzcPU6RNrehxefGGy1jHmBpSgFOHIcM59yO4JUX5aa
	 AmYINQvt/OlppoVzdOx20911PpSlzSXgAPSe8we9mgDe2c7E/W+45Qc0g3u0ERD2sp
	 az5hnW8AYqRmkWPbWCwKFDsy47B9hta7BemjND6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steev Klimaszewski <steev@kali.org>,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Chris Lew <quic_clew@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 049/440] soc: qcom: pdr: fix parsing of domains lists
Date: Tue, 30 Jul 2024 17:44:42 +0200
Message-ID: <20240730151617.678750317@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 57f20d51f35780f240ecf39d81cda23612800a92 ]

While parsing the domains list, start offsets from 0 rather than from
domains_read. The domains_read is equal to the total count of the
domains we have seen, while the domains list in the message starts from
offset 0.

Fixes: fbe639b44a82 ("soc: qcom: Introduce Protection Domain Restart helpers")
Tested-by: Steev Klimaszewski <steev@kali.org>
Tested-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Chris Lew <quic_clew@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240622-qcom-pd-mapper-v9-2-a84ee3591c8e@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pdr_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/pdr_interface.c b/drivers/soc/qcom/pdr_interface.c
index fbf91d7904482..c7cd4daa10b0f 100644
--- a/drivers/soc/qcom/pdr_interface.c
+++ b/drivers/soc/qcom/pdr_interface.c
@@ -417,7 +417,7 @@ static int pdr_locate_service(struct pdr_handle *pdr, struct pdr_service *pds)
 		if (ret < 0)
 			goto out;
 
-		for (i = domains_read; i < resp->domain_list_len; i++) {
+		for (i = 0; i < resp->domain_list_len; i++) {
 			entry = &resp->domain_list[i];
 
 			if (strnlen(entry->name, sizeof(entry->name)) == sizeof(entry->name))
-- 
2.43.0



