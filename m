Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062241;
	b=2Ui7w6JeBFru1vlsuFi8ualUZb0nRCnsTppER0ecHBqmpnQKPzMMJpSDRReMlDrPC8Li
	 2oXQjcMN9HxhQKpOXGPc8p5wHI07eZ4eNsSDVIAEHum8FXbdZqEJ46B0eceoN9Z+pmeyB
	 8PGHkFVZU4fGQ3pPHoktXEuFapUT1eSoZwmBZCnbj9SSIuEd/zf4cyW1RfNxhLuYKzlt8
	 9VgXWfaoAtU5k6tk8CdAhVjd2X4u1OVsar6Yw9xYBLT1XuWT7abXofN3tPQ0H1LwsZ1IX
	 gLuQipDBszBGxSntkYEGMipI3LPjDk477wXdUHGMLlZPd+bkMKZekulOg5VbP/8tkGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VE7RaOv3IoUcZ8Mblq3wdVnuP4BDX1JEY3al/1ixhfc=;
	b=aRD6YcAU+PjysTwM96BkACHx8hLlmyFzBGbrhkAJVDJagjFKB32vfpNm2wUJWotWfZoe
	 A0AERVDxySy85oyo3zP1yTlAThXrHhZATavxa0s/MvfPJEgeJG6WLMfdic0f8tTkoyeKz
	 SCEYTF1LwZjp7uRX62hyWOYhyZscZkiGDuJ0BwLgHmn7peg7dbbbP2aYk9F9tnMD1NmDj
	 A+GeIMyjK49bvztUoUoq5/dqWtFio9ka2tF4PKLjZ0ZTs/s5MBEPcSmY8h7twRkXXK1kS
	 Ub8N9er35FlPAuRSn4WSR+oP7HXG1b9bdUaQxZi9BQxXuOKlvlhYHWJRKnLz8QJIfWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GmqlpABw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5511606A320;
	Thu, 19 Nov 2026 04:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GmqlpABw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075871F000C4;
	Thu, 19 Nov 2026 04:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062241;
	bh=VE7RaOv3IoUcZ8Mblq3wdVnuP4BDX1JEY3al/1ixhfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GmqlpABwJSeClqz7rotzKB9ox+4AfjQQqpp64k6E6vSSyKEAJMbjQ567lo/fPJ+vS
	 R+oa9/rE23HQMoPypS4z+aU/laWHEqdV3bxl8rY96Af9by82IhWBR8rgMneejmr1jB
	 g4LFHH5KiOaHMuR2vmfb5nZv6PcnaB9fOZaUKM1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.10 1840/1848] drm/msm/dp: stop link training after link training 2 failed
Date: Wed, 18 Nov 2026 16:04:38 +0100
Message-ID: <20261118150036.603119570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

commit 9051d629dbf7a998a40f7eac65a9512b01bc3bb8 upstream.

Each DP link training contains link training 1 followed by link
training 2.  There is maximum of 5 retries of DP link training
before declared link training failed. It is required to stop link
training at end of link training 2 if it is failed so that next
link training 1 can start freshly. This patch fixes link compliance
test  case 4.3.1.13 (Source Device Link Training EQ Fallback Test).

Changes in v10:
--  group into one series

Changes in v11:
-- drop drm/msm/dp: dp_link_parse_sink_count() return immediately if aux read

Fixes: 2e0adc765d88 ("drm/msm/dp: do not end dp link training until video is ready")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1642531648-8448-5-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1732,6 +1732,9 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_c
 				/* end with failure */
 				break; /* lane == 1 already */
 			}
+
+			/* stop link training before start re training  */
+			dp_ctrl_clear_training_pattern(ctrl);
 		}
 
 		rc = dp_ctrl_reinitialize_mainlink(ctrl);


