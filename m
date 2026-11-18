Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054918;
	b=WeJFLsOpW6hqEbWvD/u76OgLT+yiDWFs+lyh0QbrMZhjwnbsuc9qPlEGObvgkWlwupe3
	 uQZCfR7k+3tNlHa2NlL0DNYL6gMEkivMjakzCY8IsrSjeT0l9CaoVzbfBM6Y71Hmeg42y
	 JBFHxhb2Bhhk5eJaB7WeYQiou7XZAjGHzvR3p4n8rPXLOLxpNmXGvdqfRC4+AC7Iw0vOA
	 p4u2DqtnhDgEG6wvASxwCcQJxWyERyLP1zEhIPxEaE/JH2Zc8yIPmVGOoSjOsF0ZDfSzS
	 D2bpAUR6GiMg2Qz64OH70Mc+hiZK+NzO8PNfWLTuXIhLplFVIlAOscNiKQPyiaydW5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qAfVgIBPg79B1w2Ad2M8Gl+ACs4e2UsitUxAyHVfMhk=;
	b=SMIFVB7QZqUCWaomMpLtbIO4cqEzVUvRoWK/nzSHL6OVgqVyA/uZHNn0OCZIckOKLtF6
	 hBiTNtJTeAvCJO0R2+HTHf1Mh6PHw4pUjI8N5e6rlvPFoEqyPc4Nc1dTEnqN+U+NLhqRB
	 NAQqJeSPYWd+U19SElH3Wid0knqA8H6bfb83va7h1q/d1lmOkKjHVdeSAdaa8+FWJBXO3
	 vgLguUWdboKgpa+Li5LDl5uEyyiCJOZmZpMaiiSpbHD/Uwq7yUHt3NBK0sEhqdQmmViRO
	 jA++GMO0Tsjoe0Bs0qs+O1H9iAuy8MsmfCfw2L3pslD3eVHx/9eG2xrh91hTPoV86Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bc5xOmFd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAFD606A31C;
	Thu, 19 Nov 2026 02:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bc5xOmFd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DBA1F000C4;
	Thu, 19 Nov 2026 02:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054918;
	bh=qAfVgIBPg79B1w2Ad2M8Gl+ACs4e2UsitUxAyHVfMhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bc5xOmFdJZk4ueULCkNiL6RUQbKFVNIuyB6YAkaKOZRJhh6G9U70I+H92jf3aDURC
	 AGzOVxvA+3WUWgwO0Yx6XUlRLrbPOAE59HoFxxoPm0FTBx2Gv7asE2puU3yoHgw/ge
	 eeV5kMlPaGdUAiLOxJT8wNn0SRM/aS8ShIQud1Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1446/2214] usb: image: microtek: stop SG processing after transfer errors
Date: Wed, 18 Nov 2026 15:52:02 +0100
Message-ID: <20261118150108.958177781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



