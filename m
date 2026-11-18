Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061136;
	b=fnlIfcLYypoMQz2bJsEwVVstoQ5Cd6fll60J8IxQ483IjkscCg1+Yq1Uu1Z2CAmWPGD3
	 GAyMC/WAr8ieyLYGOnjtTVNcdWrH05+fpOll5FoIVpUqdZKjKlkHBD5atbUQ8AwV61QP9
	 ouLOvRADy9sTeaM8OVU6AIgOh8at/f73Oy7RqcTWlVvIwbHD6gb/ZXG65bFIFjS/+RK0o
	 KaPK4y2123BEgbg4hk5rJFql998vN3bx15bBXCB+h0FQXmX2/VIBk8+JUvCpda/UEKgFx
	 JqCpqwxoewX0NQK7a8R/HLx1VjNB+PkCEZICZfTfbYdHwJB5V0JUxJlZrjWC0mdLejw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=557XsOwKdMvK0FyKwGUj64GCWLePQHgdZZn3u5Uc7ic=;
	b=RZOo7c5S1Q5sL67vf3qlFrGx5zNlFXU883Mxig/y+N1Bj6a3kRQJf8HLm2MXew4x1S7k
	 OVHDWqxJ6qwrizQ4sMvB3N3dXKwhmMOfiQC/Luat0CvLNVuQDSumNlyY4xDUQ8zeMRZXm
	 zTlBz0vejY/9uWFa0UQeC+kPODJ4CjVBGoixFTsFBrcuHYDrCIBH/MExL2QMSZDOzpxzm
	 vR34ffq+5rX3Ub9ltKEx5cRYOyIyZJ9ZsohKmZyT7dcwJvsHQ0lzcDGcp6hGR/VO23I9s
	 A18McU0ELxamG/4x1fYK9cATxe3paEadLq364qBKnNxVY5IZcgWPk/RxvULQIE+REIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+N1I4D4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD172606A320;
	Thu, 19 Nov 2026 04:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+N1I4D4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3783C1F000C5;
	Thu, 19 Nov 2026 04:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061136;
	bh=557XsOwKdMvK0FyKwGUj64GCWLePQHgdZZn3u5Uc7ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+N1I4D4hlW4RPbREXH9ld+y94XGMTy4DqJy8TEFTivYDWTAGf51w5BxGZregCJVm
	 AwFVJwoZMFiHc8RPu0rB3w/o6jkNTvQJKnRWMwIOtrRbKmQpr7yZrUq5kDN1WLYx7E
	 Pe4WHvu0zDbq0HCadrBwm35YBvVv6UDjiURjkLqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1445/1848] scsi: scsi_debug: Refuse a negative physblk_exp
Date: Wed, 18 Nov 2026 15:58:03 +0100
Message-ID: <20261118150019.945264531@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a349876633f7a583429367daf16f9a4282118255 ]

sdebug_init() refuses a physblk_exp above 15, but the parameter is a signed
int, so a negative value is accepted. The driver then shifts by it when it
builds the Block Limits VPD page, which is undefined behaviour, and READ
CAPACITY (16) reports an exponent of 15 for -1.

Refuse a negative value as well, and print it as a signed value.

Assisted-by: LLM
Fixes: ea61fca58c13 ("scsi_debug: Add support for physical block exponent and alignment")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-18-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5af545b12007e..43dc4eb7a9bd0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6717,8 +6717,8 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
-	if (sdebug_physblk_exp > 15) {
-		pr_err("invalid physblk_exp %u\n", sdebug_physblk_exp);
+	if (sdebug_physblk_exp < 0 || sdebug_physblk_exp > 15) {
+		pr_err("invalid physblk_exp %d\n", sdebug_physblk_exp);
 		return -EINVAL;
 	}
 
-- 
2.53.0



