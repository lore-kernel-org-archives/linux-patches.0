Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065294;
	b=zKcd43cPa0O4BF6rASTV5JIEABnvEAf3hSxENM3u5FoArkjsZ8s+/q2mV2+CGoKoaDWS
	 cN0UGtlpLA5rwLF56oQkCkWYU7/78f/pKJ1O6cRXh6smmxmxjmBUDw0uQjkcoZ1/Ci/y/
	 K+kzrmrgiTymyPb2dvFKK/4CopfAX27jCR8D/3AHONiA6nd/I2paKA+rm0WS1NGTZN352
	 2CjHOkkLREjx3x7RvTU+35dqXg2e5SXT3fZ9g4lmxY/FG6DZ9zlLfvARMrnGetQ/r6nxx
	 cDtm6OFPISX33hMjIY9qG9Y9vE3dv0NG2of9Llo1+uQ2JjNylqITsnuo0TO2TAxL/ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zvlBuvqIGRrOxO80zW3A2EjuNkwQy5kLlZxwvHMvQPQ=;
	b=mGwEUaU07pamKJg4lc/7DclBzA/mhuWyMg3tEJ6dT2EpOK3EEr9D9eJo2U+X3IdPEIjr
	 0PUZRp6sq0OPicuIGTTzwU97fmOYmD9JyYvWHdwIbW7B6NNd6RBZ79TpfRjCPGspdWq7F
	 22+EDh3+iEcFambFwn45/fgCaz0noLdRNK6zAX6C4wfxKfhYH9cphZiYr1d6G2qeVvoVt
	 KCiSU1BOZH8kLf+J6BRgcwm6aT/KcyPmjetZ67h6oZPMMvjvvirTN64986Bfa+LacmODs
	 LzhU5aN8B+m17Vtrqaxao1NSUj5J65ilg2w1SXJgP7LXbXSLWzM0vm3KT3J6ewcKpnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LyZqgr6m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EA0606A32C;
	Sat,  7 Nov 2026 15:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LyZqgr6m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636EF1F0089F;
	Sat,  7 Nov 2026 15:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065293;
	bh=zvlBuvqIGRrOxO80zW3A2EjuNkwQy5kLlZxwvHMvQPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LyZqgr6m6lBWNTGptmVLely5edZrAMjRbS0JZNlsMISREEUGovVgz0O9JHm8d672F
	 0elg8we0o4GMwEu6CK+G78y6nzmg4SQ1hi21/CLdz0BOaDkTjoX+zJe4lGEKQxT6hG
	 cN8+A5FTXvYvPX+lji79zH6Ca6aJA8l3eXfjhsds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1051/1257] scsi: ufs: bsg: Reject UIC commands with a non-zero result byte
Date: Sat,  7 Nov 2026 08:55:47 -0500
Message-ID: <20261107135008.322806301@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 1ae42513205a38b811afedb6797f9f9c4de37b90 ]

ufs_bsg_request() passes the user-supplied UIC argument2 unchanged,
including the result byte (bits 7:0) that only the host controller
writes. A non-zero value triggers the WARN_ON_ONCE() in
ufshcd_dispatch_uic_cmd() and corrupts the reported result. Found by
syzkaller.

Reject UIC commands that have the result byte set with -EINVAL.

Fixes: e77044c5a842 ("scsi: ufs-bsg: Add support for uic commands in ufs_bsg_request()")
Fixes: 9fb4c793223b ("scsi: ufs: core: Complain if UIC argument 2 is invalid")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261015001855.3450573-5-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 7aecbb290e658..baf6ae917d36e 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -179,6 +179,10 @@ static int ufs_bsg_request(struct bsg_job *job)
 		break;
 	case UPIU_TRANSACTION_UIC_CMD:
 		memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
+		if (uc.argument2 & MASK_UIC_COMMAND_RESULT) {
+			ret = -EINVAL;
+			break;
+		}
 		ret = ufshcd_send_bsg_uic_cmd(hba, &uc);
 		if (ret)
 			dev_err(hba->dev, "send uic cmd: error code %d\n", ret);
-- 
2.53.0



