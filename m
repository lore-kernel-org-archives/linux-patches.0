Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22721C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742BEC433D2;
	Mon, 20 Mar 2023 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326131;
	bh=+VEgy72F1QjY0tuJ8WiJJbx7PTnp3rXHxyhXYZZhz+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ik3HDOgemp1/p2vmwgk1r9hczf5D4jECqwxtoMP583vUdJw/rmveSlt3D6JtCfY3x
	 9z93iwTFoHxa1N4StiJ9jz6Q8JzFuC8dO1g+Ctey+tt248wc7WbcdWZlCjJ63lsYxY
	 9iVJ7an8WP2CiofbrX0lGLxxMJ/u9jGzvY4Y5wGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 143/211] cifs: generate signkey for the channel thats reconnecting
Date: Mon, 20 Mar 2023 15:54:38 +0100
Message-Id: <20230320145519.429602514@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

commit 05ce0448c3f36febd8db0ee0e9e16557f3ab5ee8 upstream.

Before my changes to how multichannel reconnects work, the
primary channel was always used to do a non-binding session
setup. With my changes, that is not the case anymore.
Missed this place where channel at index 0 was forcibly
updated with the signing key.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -425,7 +425,7 @@ generate_smb3signingkey(struct cifs_ses
 
 		/* safe to access primary channel, since it will never go away */
 		spin_lock(&ses->chan_lock);
-		memcpy(ses->chans[0].signkey, ses->smb3signingkey,
+		memcpy(ses->chans[chan_index].signkey, ses->smb3signingkey,
 		       SMB3_SIGN_KEY_SIZE);
 		spin_unlock(&ses->chan_lock);
 


