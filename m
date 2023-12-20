Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DAD40C04;
	Wed, 20 Dec 2023 16:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2j8LSuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD7BC433C8;
	Wed, 20 Dec 2023 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089025;
	bh=EOqxbYtLfC0EjIrhVf1EhE2vgCmkPqIeCh8XsFtk1kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2j8LSuZumnoNslTfmKGg0sKrHfj/6/Lvt1QDBa3SBqCkjlHpHuEH8ejz8HNIuozD
	 HMUK2OvhgtfMNcb16wn/Ls8F8haKp/x3SlhXn8/DTg+n8+0mFinhACZnNs/HUkNDPV
	 6YX4arDvr27sAxvYEmMTOMb1h/sXozYFLJ1hMbes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 125/159] ksmbd: add missing calling smb2_set_err_rsp() on error
Date: Wed, 20 Dec 2023 17:09:50 +0100
Message-ID: <20231220160937.147819432@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 0e2378eaa2b3a663726cf740d4aaa8a801e2cb31 ]

If some error happen on smb2_sess_setup(), Need to call
smb2_set_err_rsp() to set error response.
This patch add missing calling smb2_set_err_rsp() on error.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1904,6 +1904,7 @@ out_err:
 				ksmbd_conn_set_need_negotiate(conn);
 			}
 		}
+		smb2_set_err_rsp(work);
 	} else {
 		unsigned int iov_len;
 


