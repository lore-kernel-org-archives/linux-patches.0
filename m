Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020325;
	b=XAtFFVdLVKH6BxYm+68RkmYfmZ8MD/avqquanZiMxhmE/T/+fH7mZdQebUJzByHza8f/
	 gfGP/+yNQtvre/eJFtOksTjutr87WS00pKHJ4J1oiQrX3xki+el8+SRM0TqQXe6ErIVne
	 uqyieBBWwmduWVga8O4wbn/i2VLV3dRELVT5pVjliGim9whhBkKNbOibj/XubPqBbfHHa
	 Pq9CnZv3Mj7B5r70qssh7yKMyfF1unHzTurf2PI8lTA2JJGNnhBM2o0oG0rPzDACc1kth
	 epG91vlBh3e+rIG5kfbPFoCiUJFI6HcZAHUXVf4UzMEz3jd8lSy4UGSSWXXa/P61jpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U/shQK6eMl1wSaiElrvpD60Ac2zqSolLX69yHCQp6dk=;
	b=m8jCrhab1N+AKOJZNgdIhXe3Gjcak5W6yWTEXB8Qm28UCwlCIOD9A0a/yGzdH/fiL8qy
	 FDAYGxLhIyloUr0IIAYkq7eJocOSMH+9NCEnJk93pkTd/szX7Cl3QHfOHlXSjprcdpsw/
	 k/f1DUXcd2ZWd4MJaMlJN7GgpJ4hUSpxmgtGacVNbGpP/WQAK+dx9HhSI5psVoS2V7Dvn
	 xQUy0ObAfMBWW8IPD5OzvyqRGpgmnFSBiqMeFXi8WpSH1G7fM0oVu6hv0oaoQTa7y31ZS
	 NFAijW3JhgOpFRFPahCKDX7aPba9MFrfm7sXKMwhGWODpba0ri3cGDd0Rdbk0Bn6kAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHuVsyAp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F23606A32A;
	Wed, 18 Nov 2026 16:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHuVsyAp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2101F000C4;
	Wed, 18 Nov 2026 16:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020325;
	bh=U/shQK6eMl1wSaiElrvpD60Ac2zqSolLX69yHCQp6dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHuVsyApkfyapxqDyftfp+M49tPcXhobgpDDTk8tOZhS2FUoTCO16Tu9J2hYtenX6
	 kRVbIdaNtv735ipBuPUjnhrCXexpHUQcuDdAGb9hTmJKwOEPm/VunX7KXYFNOtHaJO
	 G8SeJdf3gmeDBm1yNeeW8l67ZSbTvjC62iXEQ3/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1910/2651] net: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 15:52:30 +0100
Message-ID: <20261118150355.551316532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit fbd3a301b1378423a5cfc23a42e3c0b04e26192c ]

The loopback hook gets a shared skb when another ETH_P_IP handler is
bound to the device. skb_unshare() does not unshare it, so
skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).

Use skb_share_check() instead.

Fixes: 3e1e58d64c3d ("net: add generic selftest support")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/selftests.c b/net/core/selftests.c
index 36b949ae520b3..80029a67b2d2b 100644
--- a/net/core/selftests.c
+++ b/net/core/selftests.c
@@ -170,7 +170,7 @@ static int net_test_loopback_validate(struct sk_buff *skb,
 	struct tcphdr *thdr;
 	struct iphdr *ihdr;
 
-	skb = skb_unshare(skb, GFP_ATOMIC);
+	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (!skb)
 		goto out;
 
-- 
2.53.0



