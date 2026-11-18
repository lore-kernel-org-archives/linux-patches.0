Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023387;
	b=j/r6T66R3fCjEYFJPZYPvOirLOmPTp4nsODpFH3mAdSG7NaPQBDv/TwLq+ZeD6xQI95V
	 FQrvHzCO7HEacdGxXuHI0fW55zHLf2oNvuyG9iXnz7k5ZmoTnkTfECH2zDfJadU0qpfon
	 96wSvpQHQPe6GA93TeZ2dpA58SaktCaOtO4eCo+uBhE5o1pSkBFdL/CjOXjYUhv0lLsE+
	 4hVc3F0BlTVUOPkJ2lq8P8R5dfYfbqbTPxJgm0HbT94VzRZGa8RxcO99LF/hA+uRiQ+z9
	 /h5mCOjosTTP29596iLB1FrvkfyUcLwy399jOkxfDuzGoA2PjVn99qrtMOdsrXw4Dag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4hPFXI4XTiwagb8YNM+E9UCSgD0TXNWx4wsa563u1kU=;
	b=YWmFbgyGM6ph3dwg7nrdOe9a6LFF//iEDWt7Bcnmx6dtJ/hgob63WCat+B8fCvZ35t6f
	 f4MX6mas9VQ3k4HhjyEheAdFCkKmuS6TsThYwRWWn1KjI895PIYAqVtRhEE966oeupQmp
	 3Rnw4YCXGo36rm8CeIszcEMn6sZdINxHp4gKqt3pljjjhYthNGmzTD2UFFVUHnm9SGSYP
	 nifh9QpFuF9WJQtyGgmGyz5+mJCbDeRrwNSEOlRzScfCO+OnDlVRECqTboYFF1o4C4DRX
	 FpplgL248tTbUnC5HnnYoxPOHzMLqzbaW7Vf2bjd1UqRKORjfvzaOX3tqjmwmlFmBwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EcLr7BSy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B33F606CA60;
	Wed, 18 Nov 2026 17:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EcLr7BSy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBE11F000C5;
	Wed, 18 Nov 2026 17:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023387;
	bh=4hPFXI4XTiwagb8YNM+E9UCSgD0TXNWx4wsa563u1kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EcLr7BSyiKVcC/krxIbwiO3YilZGvp+Es8jVFuGeCVeRIIZH9nOEVQ49QjLDh6KwM
	 WrACXAAl2SDaTs2388dXguQYLmLREHvJgnKWJkUksk4aslY1kqCJDcJZCikAJ+xDKE
	 qRdzektZCMHA97qwC2DUd3tnKdigkg7Hmnf/tJXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0352/2151] usb: image: microtek: stop SG processing after transfer errors
Date: Wed, 18 Nov 2026 15:34:47 +0100
Message-ID: <20261118150134.922299393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 934ec5310fb97..69058cb87368a 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -495,6 +495,7 @@ static void mts_do_sg (struct urb* transfer)
 	if (unlikely(status)) {
                 set_host_byte(context->srb, (status == -ENOENT ? DID_ABORT : DID_ERROR));
 		mts_transfer_cleanup(transfer);
+		return;
         }
 
 	context->curr_sg = sg_next(context->curr_sg);
-- 
2.53.0



