Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047448;
	b=36z7pbxr5M+OPcujFoco/DRQ7Wooa2u+rtkUs3ZeyMsb8SAkU4/rfFkQnxOlcj1zVb3D
	 Z7nGzZR50uNmSw+NPalGz/+2Jadg4EwdspTfdIUS6eynAEcKeF9e9AfdUtasuqGzfMSAG
	 cr7OM2hYktbCh+GoGrsPaAVLN61b52J2TOo6IqBwI33KrEnSfenJkJvK3edlbKpleltoV
	 u4VFoquC/Cc0Q4Fa8iy/LXBbfqlRVir/en7Q2bq7EQknrDQtsiIlcOaYBiztjKrv3bcKl
	 53zgUfdOQyVlKYj/wPzj0UCf9LkYTtD8sfzeAnaLXE3e6HA0hQSbn4lxxoN7GZjgpvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=O0tQL8e1VjCuB8/zrwp1w7d5Mg5xnA3/HAmlNRmJTWE=;
	b=qA/4g/x+zXfiqJctWA2z9cjNESr4enFEh1UJzqy/6KfpjJCFvHBvS9mMJwNQrmtSbmY8
	 JVWL00jymwLfs6//pVrgwZQ0vBnKgZq54qEgoWv8WcUJEMjNR+Uo0d7WiS5NRpslunqOI
	 g2VNFPE9RGcRQXXZM+ekx6ZB+UqfdpMwJnexvl55myc5Ppk4ihRLypa5F9yH4hQ6vbqlI
	 /uLp5DdSn17iezlC81jg1GocAVNfsDVMPL9zWwArX8kmQJ3yXI46kQ1JTsuLHcvITc8aM
	 Qw+b8hRLQSdA/62J4TXWYxwVVpb9DbT3iuLXD2LhO0vmDcbfR+v2axZ3PVr51XBywXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zsEjrKU/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE58606A31C;
	Thu, 19 Nov 2026 00:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsEjrKU/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB891F000C4;
	Thu, 19 Nov 2026 00:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047447;
	bh=O0tQL8e1VjCuB8/zrwp1w7d5Mg5xnA3/HAmlNRmJTWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsEjrKU/4JaNKuXckhyA+BGMWuOGS/z22BliDCZmtfzxCu7EKudwGrHr4DN+tbEPZ
	 ERVVwwiavhJhXIMtYYybDtvXUFO6feRv/yzxIwSB+s9+VkqOaCm9XbovZRTSvGvEyQ
	 A3pzhw1C0/t3sIMZjTvdfXcEZZ5Bmrtzfa5eQSR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1601/2857] splice: fsnotify_access(in), fsnotify_modify(out) on success in tee
Date: Wed, 18 Nov 2026 15:43:55 +0100
Message-ID: <20261118150259.018655790@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>

[ Upstream commit 576d498e0ac5caff2d9f6312573ab54d98f12d32 ]

Same logic applies here: this can fill up the pipe, and pollers that rely
on getting IN_MODIFY notifications never wake up.

Fixes: 983652c69199 ("splice: report related fsnotify events")
Link: https://lore.kernel.org/linux-fsdevel/jbyihkyk5dtaohdwjyivambb2gffyjs3dodpofafnkkunxq7bu@jngkdxx65pux/t/#u
Link: https://bugs.debian.org/1039488
Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
Acked-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Message-Id: <10d76dd8c85017ae3cd047c9b9a32e26daefdaa2.1688393619.git.nabijaczleweli@nabijaczleweli.xyz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/splice.c b/fs/splice.c
index 418c03d9b9f84..c6649cd36c21a 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1722,6 +1722,11 @@ long do_tee(struct file *in, struct file *out, size_t len, unsigned int flags)
 		}
 	}
 
+	if (ret > 0) {
+		fsnotify_access(in);
+		fsnotify_modify(out);
+	}
+
 	return ret;
 }
 
-- 
2.53.0



