Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E5C299959;
	Tue, 26 Aug 2025 11:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207370; cv=none; b=ibQpBE+ny3Q0IStmPa3xWOAAjqJGcdDn6AqPvbiu/ZAiXLY2IJ3VjzROHHC3E32QaGVvnwSRRnkkkq8CKvxP+DI06wZXgJMXY25iacd7wWdliw1BGCihNFrw5MrqlfmuL5Q70/1dToFrjlbmLDIdmfNM95TDs4gVPKDfvXd8LGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207370; c=relaxed/simple;
	bh=VfCk3fIJwtZluGK+PIuy/SHAxklW0YdHFh969RAydDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/8kHuWfHRC5QcGanL6lfoUuSgRhCOPHVipqSu8d6+HSTJY4z/OvAEj0ZeJ/Oe9fUCJJHqnn17yltCVmi27W0DMAlyHPeVFv8+xRx03+708i485xIk8wXM6RKiiKCRZEiJMh++cSJJc5+GDh71mTZqTLY5Roc2oIO/rCCFRETvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTuenE1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTuenE1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A64C4CEF1;
	Tue, 26 Aug 2025 11:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207369;
	bh=VfCk3fIJwtZluGK+PIuy/SHAxklW0YdHFh969RAydDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTuenE1eboHEPzSQpHAdvIqSvlgvISj3OUKem4Lq/o7HXzoCzmeQwRsSpxjoGGAQF
	 iL9lcDKITs5noMsBr2au3u7IyqGURE44rfDYFwJKoKUT2K6bpXzhdbmQYip8Zp0BnE
	 e8SU43eRa6lZhAhryfCyMmPSG/jN+mx+rrIlixxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 156/457] media: iris: Fix NULL pointer dereference
Date: Tue, 26 Aug 2025 13:07:20 +0200
Message-ID: <20250826110941.230106322@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 0f837559ccdd275c5a059e6ac4d5034b03409f1d upstream.

A warning reported by smatch indicated a possible null pointer
dereference where one of the arguments to API
"iris_hfi_gen2_handle_system_error" could sometimes be null.

To fix this, add a check to validate that the argument passed is not
null before accessing its members.

Cc: stable@vger.kernel.org
Fixes: fb583a214337 ("media: iris: introduce host firmware interface with necessary hooks")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-media/634cc9b8-f099-4b54-8556-d879fb2b5169@stanley.mountain/
Acked-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # on sa8775p-ride
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c b/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
index d1a2a497a7b2..4488540d1d41 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
@@ -265,7 +265,8 @@ static int iris_hfi_gen2_handle_system_error(struct iris_core *core,
 {
 	struct iris_inst *instance;
 
-	dev_err(core->dev, "received system error of type %#x\n", pkt->type);
+	if (pkt)
+		dev_err(core->dev, "received system error of type %#x\n", pkt->type);
 
 	core->state = IRIS_CORE_ERROR;
 
-- 
2.50.1



