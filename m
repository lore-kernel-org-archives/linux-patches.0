Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064360;
	b=LnvRWnLiC7tuDXX4b4+uUAih27F49XIuYROK0FCcLrk3hJ43aN/lAWMgjAmL3F8xTf+x
	 bTeB/sLJZIXvVUi4kHLhnseKSgtEfXUk7bQ4zml/llUTWnuQVKYQnp6V0hQjdjxZhq7kg
	 lHjbexks8fXeW9k0IFGiO73eAMDuNBOPJXWR/rhpcN6Vv5IJZhZ6G4Q8ESO5XxDbyOHoH
	 qkiIzO6ZYUqlj2xRDVUxbVWZFzE5hkm2oYNFBacw9iN0NisDeXRZZCNQQU2OWNoaDp5ID
	 d8UF09BbwDCAcd5YTddahK/vZIagJzvKa5Seo6XYRcP0ybSLXe9l67kEZLEky22XUXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jk9b++eCiXM5xaecb+6b6671soUt2KTjZPtobVGLT+E=;
	b=gkeTQj84H8WEGi007EkIYMgvI+rvdVhQ6A+ap/YYVOFGPqQt4v5D1dWVebrL+okMSy8w
	 EN3LjcAVtIJYNoWy93bNXYkZiWYrunjddxo1jHNpJkPDPYwZoTYj56fIYISjemvL6Abw8
	 brBQn3NzM46+ew05weDfjrTGXu3ybSGdLoY2XlhEPYz4Ql3J5sDIZfVqopP+AHht1FdRG
	 oeU0XD2wHbKgIrQlKh/5QjobMtS6t1pWdXFvQDoy/w4mZpqQeyzlhDT8bBse/fBpz34Ja
	 S1KasRE3H/6sLpfnTn1KUIKm3jTRjyYK5Xfs1U1UUSIOwG7XDXQNl75r57kzu5E5rYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A4hjKuMw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E234606B88D;
	Sat,  7 Nov 2026 15:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A4hjKuMw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5D61F0089F;
	Sat,  7 Nov 2026 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064360;
	bh=jk9b++eCiXM5xaecb+6b6671soUt2KTjZPtobVGLT+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4hjKuMwTFYi3IoIhy0WJRwj3iX5DZFt8k1s/7VUMicJ2w4bO54iTAjz7Yd8ZNP20
	 F4HDN5OAER1zravA5/8GntfzrubhuXLMpyQTMNUNB5/p5zqGOZYB4B7TAOzAHunLkr
	 1q+NiliBwEzJF1wUHNhEzKkHTsWC+9SnXVYUBPK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cristian <p4ulcristian@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Janne Grunau <j@jannau.net>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0442/1257] phy: apple: atc: Support DUMMY PIPEHANDLER state in configure_pipehandler
Date: Sat,  7 Nov 2026 08:45:38 -0500
Message-ID: <20261107134951.690886344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Sven Peter <sven@kernel.org>

[ Upstream commit a2fd3d1f4db720ac1deb477ce4811c5e4e60e5f8 ]

For both Thunderbolt and DisplayPort atcphy_configure_pipehandler is
reached with a request to switch to the DUMMY state (i.e. usb2 only).
With the current code this breaks USB2 when all four SS lanes are used
for DisplayPort AltMode because the -EINVAL is passed all the way back
to the phy_set_mode() call which results in tearing down xhci and dwc3
again.
Let's actually handle that case correctly and also drop the default from
the switch such that we get a compiler warning if another pipehandler
state is ever added and forgotten here.

Reported-by: Paul Cristian <p4ulcristian@gmail.com>
Closes: https://github.com/AsahiLinux/linux/pull/515
Fixes: 8e98ca1e74db ("phy: apple: Add Apple Type-C PHY")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Peter <sven@kernel.org>
Reviewed-by: Janne Grunau <j@jannau.net>
Link: https://patch.msgid.link/20260821-b4-atcphy-usb4-v1-1-45c0b741e0c0@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/apple/atc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/apple/atc.c b/drivers/phy/apple/atc.c
index 4156fabad742c..a3162f25e6cd6 100644
--- a/drivers/phy/apple/atc.c
+++ b/drivers/phy/apple/atc.c
@@ -1121,7 +1121,7 @@ static int atcphy_configure_pipehandler_dummy(struct apple_atcphy *atcphy)
 
 static int atcphy_configure_pipehandler(struct apple_atcphy *atcphy, bool host)
 {
-	int ret;
+	int ret = -EINVAL;
 
 	lockdep_assert_held(&atcphy->lock);
 
@@ -1136,8 +1136,10 @@ static int atcphy_configure_pipehandler(struct apple_atcphy *atcphy, bool host)
 		ret = atcphy_configure_pipehandler_dummy(atcphy);
 		atcphy->pipehandler_up = false;
 		break;
-	default:
-		ret = -EINVAL;
+	case ATCPHY_PIPEHANDLER_STATE_DUMMY:
+		ret = atcphy_configure_pipehandler_dummy(atcphy);
+		atcphy->pipehandler_up = false;
+		break;
 	}
 
 	return ret;
-- 
2.53.0



