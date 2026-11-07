Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064695;
	b=jkX6ifeUr+4FyLZGTP1zt8UfkSd88dhI+Sn4WPTXlI+sswvRHrG2lI5V/NCpQpkMpn/e
	 BsaPtTCYaZJ/Hf+eL3587jjdzvWdwCA6JKYBKo0f/xJvfhj+ziDTFx3E998bmm+pckoyy
	 K72jF0DiTl4iiScmdpXcVTO+6N1LosY3yQj2A15UYGa9asSGLm7YjJIvMYVCEDXMkypzL
	 LylAhgPPPeBSYhntgG9kZ8dxBqG9hOTFfiTe2xvAy7kRttGD4TV5n68JZ2ZKAbygTRe5+
	 gY83mfDISPC2r9nwGlekqTN2ZdYUqDIjFOweuMUsUQLljynY51aFnmbKYRbfsGPZSgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3pEW26wILPBlMf9h/ptptyqLlt9Eof01j9MfV/J+y8w=;
	b=AuaMHcmMIOlntW+VwOfdzaosBxPZ6ULG+K152ozMT1sdn2Cvu8zWSgC3+4qQ9QSxD6Rs
	 AOYCTzqMDoyrsP28dyaSnn/KlG6wWniGSTQm0E0MAVckQeNviMa9lG6ptQQg2O9LIm/xo
	 4NiJ/dwbfS4qrgvAu8lL31IIvg5KHjyCf8EZ+L3FQW+42b38ChJmLn99cCdcSa8fOQr+F
	 GRLuALl5KuqBfUJX9e3xgLMN0UVtvsWdzqpzMKCPxOdglKKMqe6Yyu3EpyzZv+NnEISZV
	 hbvvXGV4oOJbkowZ1bBmiLGH6Hno1av3rfemddgXAQnVqE3UJzM0T9+BKAb2JEYQrgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nyM2O3Yb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B425606B8B9;
	Sat,  7 Nov 2026 15:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nyM2O3Yb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B30A1F0089F;
	Sat,  7 Nov 2026 15:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064695;
	bh=3pEW26wILPBlMf9h/ptptyqLlt9Eof01j9MfV/J+y8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyM2O3Yb7jYO/0x6gEBFXHeKB7bMXNGQASq+7sUDAW70/NcMooZAi+mb8PH9+L5Cq
	 5wGIGM6ES4S7k0eld7tfifcsewfWhX+8PgZRQl1ZU5a1+kIroX9pV3sZ2RfzkyEpLx
	 lq8i1nAWR2wPXk42b3ZsVCn1wMx0sGMmT1iEKEfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0686/1257] fbdev: smscufx: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:49:42 -0500
Message-ID: <20261107134958.214162988@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 8ea6c6e77ccf887f3e68c64f4c261071a345da1e ]

fb_deferred_io_init() allocates deferred I/O state, populating
info->fbdefio_state, or leaving it NULL if an error occurs.

Currently ufx_ops_open() ignores its return value.

Therefore if an error arises in fb_deferred_io_init() (for instance, due to
an allocation failure) info->fbdefio_state is left NULL.

fb_open() will then dereference a NULL pointer (calling
fb_deferred_io_open()) as soon as ufx_ops_open() returns.

Additionally, if the allocation of info->fbdefio itself fails,
ufx_ops_open() sets info->fbdefio to NULL and invokes
fb_deferred_io_init() regardless, hitting BUG_ON(!fbdefio).

Fix this by only invoking fb_deferred_io_init() if the allocation
succeeded, and checking for the error.

The driver already supports operating without deferred I/O, so in either
case fall back to that by setting info->fbdefio to NULL.

The ignored return value was introduced in commit 56c134f7f1b5 ("fbdev:
Track deferred-I/O pages in pageref struct").

However, the BUG_ON() issue originates from the earlier
commit 3c8a63e22a08 ("Add support for SMSC UFX6000/7000 USB display
adapters"), so target that for the fix.

Fixes: 3c8a63e22a08 ("Add support for SMSC UFX6000/7000 USB display adapters")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/smscufx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/smscufx.c b/drivers/video/fbdev/smscufx.c
index 5704f60e1741b..34d8abd5b3544 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -1041,10 +1041,13 @@ static int ufx_ops_open(struct fb_info *info, int user)
 		if (fbdefio) {
 			fbdefio->delay = UFX_DEFIO_WRITE_DELAY;
 			fbdefio->deferred_io = ufx_dpy_deferred_io;
-		}
 
-		info->fbdefio = fbdefio;
-		fb_deferred_io_init(info);
+			info->fbdefio = fbdefio;
+			if (fb_deferred_io_init(info)) {
+				kfree(fbdefio);
+				info->fbdefio = NULL;
+			}
+		}
 	}
 
 	pr_debug("open /dev/fb%d user=%d fb_info=%p count=%d",
-- 
2.53.0



