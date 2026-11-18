Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048223;
	b=UlUK30R3i33v+GO6osA+4DOk0+AfIBMRZYTlRZkgPHW8ZXPgCPONSUrN+aHN3zXWruwG
	 iw3oG1WZB+Vl/9lA+Uy/yPBjY2mJAvR7HbYzdtm8h+lB3Vvmxi4v4fWQo8CmVnX/vdQlS
	 UrSF2prtw0XZkACiKsnM2d1lWs49mdKFYWjmv7jp6Tpv3v7KhgVYxuElc0nm3IslwXyHD
	 7VvDf8kg66ldujp0FGcZ7ch85I2rj0rQ7/HQyXjCssiTxDv/Yi0clUyT5DIkkksUYgp3H
	 iIgs72+2CxmthBNPXtsxoezLMRufRgTBd0k2XCs2Pu3zucU0Lh0q1YH3YZ9JTUW8k6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0rLrciiCm+HnVgj3RkdXixl93E1P+/LNb50qsQr+3Gk=;
	b=US3llJyhvpztLuJNTYhT4JnJjLPaKDdZs8zuo25JzFae4Mv6qvWTEreTWohssc3hfxH8
	 oJwIaaUYl/S8AWqZHK7AgS9tM73SiI8YwSoimpjD80xvvx4HOEMLajFtKWdEia011+qyy
	 1wFTDHp0kFLNkTqqNOYEvTp5nHSuBaznuvRB7qmysC18N6DL+9Zw7WGNNUtf2qmb2/81r
	 8aWJPXMpgY4VlBpAeveH83otxLuag131at/wqxlKRY1br/8Dg1ahxo4m8+iqcWtkqY9kw
	 q4nKECTccdwOA1+yehfBzZ0QMKRPJhmmnFO9Va2sOn/G8Qezjmisv+wGCJhXZfNVGOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iu+GPSI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041AC606A339;
	Thu, 19 Nov 2026 00:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iu+GPSI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB1E1F000C4;
	Thu, 19 Nov 2026 00:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048222;
	bh=0rLrciiCm+HnVgj3RkdXixl93E1P+/LNb50qsQr+3Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iu+GPSIW3ZGEgOQVDXqhy0iSVsQvUP1MIixF3ugnRgJuv6H+17YlPxkYY8bCr5WD
	 pTY4enzPKUyvGwcGwWDLVuu4RP1hsaurreVSmzLenHtbx1SvOBgebf0RreboXWQlPL
	 CzKhjQpN6L7la15yUZUnemyd+wkMnB/OOStyAP2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1901/2857] cpuidle: menu: Remove incorrect unlikely() annotation
Date: Wed, 18 Nov 2026 15:48:55 +0100
Message-ID: <20261118150309.677027719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit fcbd7897b871e157ee5c595e950c8466d86c0cd5 ]

The unlikely() annotation on the early-return condition in menu_select()
is incorrect on systems with only one idle state (e.g., ARM64 servers
with a single ACPI LPI state). Branch profiling shows 100% misprediction
on such systems since drv->state_count <= 1 is always true.

On platforms where only state0 is available, this path is the common
case, not an unlikely edge case. Remove the misleading annotation to
let the branch predictor learn the actual behavior.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260105-annotated_idle-v1-1-10ddf0771b58@debian.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: d594187cafd5 ("cpuidle: menu: Do not return a disabled idle state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 2aa87ce37a904..5bdef6470ca12 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -314,7 +314,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	nr_iowaiters = nr_iowait_cpu(dev->cpu);
 	data->bucket = which_bucket(data->next_timer_ns, nr_iowaiters);
 
-	if (unlikely(drv->state_count <= 1 || latency_req == 0) ||
+	if (drv->state_count <= 1 || latency_req == 0 ||
 	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
 	      latency_req < drv->states[1].exit_latency_ns) &&
 	     !dev->states_usage[0].disable)) {
-- 
2.53.0



