Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E406265CA6;
	Wed, 25 Feb 2026 01:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983500; cv=none; b=O1wnHbBsNb498fIVCSKwIo5CwG7EEG6twnx/IZgYDDODNvMTdM/1CFJMrZ1JfalzdD1x29ZvQdx03avWlGGa/kVky6R+olins7VpdCPLeqOkBGgKAHke+NgT1e1WAYLQ7jFv+qmMlQNdTnzlmM3rME/a/Vrf5IDcjD7y0LODkdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983500; c=relaxed/simple;
	bh=9TzZolh4V+eUAok4iAyNYJWIGnrsdKqjIiz9+Wa6Shs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rinWdZrIInhkC/gitcVcjG1vlnjwjykfeqeRyJXJdRJFgzau+MVkha6pgRls2sjTWO+2rZqxE/+pyJMypzbn2NCXsCL8lzyIM/xpBoQVyFsHVW6I3lgNO0S/IElyHt84AAs06dYsfIAoHjqFAa+ow6gazjSdVmr2RUtSa+2GIxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/6KkENU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/6KkENU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BCEC116D0;
	Wed, 25 Feb 2026 01:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983500;
	bh=9TzZolh4V+eUAok4iAyNYJWIGnrsdKqjIiz9+Wa6Shs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/6KkENUv37fo9YBEDEsj9noPXQBPFdqXI3xaVrBPSJ2MNsKmRmyunlLLqcsTbdkt
	 UrKGJ1JHXdmjr2HVeXMCk4w4NYeSlGmKIgFRnERUSIkwObTkZftKA4T44igBI6UQLe
	 QbfdBiaoxRbHHRZKoBRa8uCImuSkyc5IZK1JiYsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 609/781] backlight: qcom-wled: Change PM8950 WLED configurations
Date: Tue, 24 Feb 2026 17:21:58 -0800
Message-ID: <20260225012414.732371530@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 83333aa97441ba7ce32b91e8a007c72d316a1c67 ]

PMI8950 WLED needs same configurations as PMI8994 WLED.

Fixes: 10258bf4534b ("backlight: qcom-wled: Add PMI8950 compatible")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20260116-pmi8950-wled-v3-4-e6c93de84079@mainlining.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 5decbd39b7899..8054e4787725e 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1455,7 +1455,8 @@ static int wled_configure(struct wled *wled)
 		break;
 
 	case 4:
-		if (of_device_is_compatible(dev->of_node, "qcom,pmi8994-wled")) {
+		if (of_device_is_compatible(dev->of_node, "qcom,pmi8950-wled") ||
+		    of_device_is_compatible(dev->of_node, "qcom,pmi8994-wled")) {
 			u32_opts = pmi8994_wled_opts;
 			size = ARRAY_SIZE(pmi8994_wled_opts);
 		} else {
-- 
2.51.0



