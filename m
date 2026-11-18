Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060458;
	b=I13vQ4LqMfnbTWDOJ5t0kHdpLtT/f1oWcHVTWu8z5bJFD5eKllU5XrUyMRzOKiLw7YYy
	 9rOolVxmfBOb7jZ8tSimcIDOo2Ibfj9rB8UujGCUwYZBBKH3wsKRMN2eJOTNBoyXQb/ZV
	 GeN+KOBwW4RVo43t315JvdaEaXX3n1ouJvK/mw6KAZNht46kDCyoziGMEtSfWKsHMhHcd
	 +oZAgzZQEqmC/ISnEfdR2tJXTfjBQpHK/acygSWAs0AjZkfc6dsHQ7EWRvQ9Op6tjAo5d
	 P6Hom/yAQpWmDMsIFd0kKEWRW7yW3chIS8/XZsgzcLQ8x3EFNt32ONtWTTGJ25qXOdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=seNXe/4KLKQHOEdkRCzAnXZG56V27Ej3xSwbN4jUECo=;
	b=U0FeaR3ToJ5rfdIrgisryL/Yh1EXc0dnUa05f5mUWuKnByzxn4pjvsc4BcIHKCMCE4QR
	 PZrETcvVfvHxaDbtgkHtHrZQSx7EVFU/izEFcIEJmVWH8i+2h4yEAMJZIzfS6EyK7K8Pk
	 SBoWjoqx/vKyY61iBfD077EsjOdz8i9krz3QUpXn4idbztQ45Q+s8ACJXzDbqxF0gYB1L
	 SFK+D0hY87nhTzjBjh9i9EShjUTSwBHACuKW4KrT/qlJihmUlK10IPcQUYsVG1C6jA4Ix
	 RlbzbpPaI7zTlxC/OKlXEmaJ88d6N+/G/2DGJdK77i5/fFlAj4E21EWpXTlV5kQhw4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCoQVtgU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A4B606A325;
	Thu, 19 Nov 2026 03:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCoQVtgU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8531F000C5;
	Thu, 19 Nov 2026 03:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060457;
	bh=seNXe/4KLKQHOEdkRCzAnXZG56V27Ej3xSwbN4jUECo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCoQVtgUYIGYo8uCA5pz0NHe2t7GGUjK7n5LVcLub65n/WLqxRupdulyBhi3mE+NS
	 JXsrfrRdiplHmQp/qezO/0vsIMsPk2PlNOhYH0pTy9Ss7mIDwYgHYP0J53oJ8o/p6K
	 XnKQDrjEgd8ImpSD3bD29W3y4QVHJFntE6EzH9Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1207/1848] usb: image: microtek: stop SG processing after transfer errors
Date: Wed, 18 Nov 2026 15:54:05 +0100
Message-ID: <20261118150010.539370245@linuxfoundation.org>
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

From: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>

[ Upstream commit d937ca39cc44a01ce64865dd25b1e205a05ae3a0 ]

When an SG URB completes with an error, mts_do_sg() calls
mts_transfer_cleanup(), which completes the SCSI command through
scsi_done(). However, the callback continues advancing the scatterlist
and may submit another URB for a command that has already been
completed.

Return immediately after the cleanup so that no further processing is
performed on the completed command.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260723195654.152104-1-diegomancera.dev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/image/microtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 59b02a539963b..5787751cf6bb7 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -497,6 +497,7 @@ static void mts_do_sg (struct urb* transfer)
 	if (unlikely(status)) {
                 set_host_byte(context->srb, (status == -ENOENT ? DID_ABORT : DID_ERROR));
 		mts_transfer_cleanup(transfer);
+		return;
         }
 
 	context->curr_sg = sg_next(context->curr_sg);
-- 
2.53.0



