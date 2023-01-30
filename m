Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8D428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BE9C4339B;
	Mon, 30 Jan 2023 14:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087466;
	bh=uiFcGnQF1khghIzvlqlCvSKjjDsigoFBSOPPxnPsdxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2XXjWDF45ARAwXnpcpLaOlXHwGmkXYszaogHzOS3K7cqeDnX3nmIu7TX/BaIyM9Kg
	 c7cAQEecCUfkivTxn/hQYG/q+P6JNRnGZ1073ZYNWYlaE6l5ks0JASFmDeW1nFeH85
	 irdDvhh7vtjNudGED2vIHoGcXO6y2Y6kNp+L8Ptg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 218/313] ksmbd: downgrade ndr version error message to debug
Date: Mon, 30 Jan 2023 14:50:53 +0100
Message-Id: <20230130134346.859099057@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit a34dc4a9b9e2fb3a45c179a60bb0b26539c96189 upstream.

When user switch samba to ksmbd, The following message flood is coming
when accessing files. Samba seems to changs dos attribute version to v5.
This patch downgrade ndr version error message to debug.

$ dmesg
...
[68971.766914] ksmbd: v5 version is not supported
[68971.779808] ksmbd: v5 version is not supported
[68971.871544] ksmbd: v5 version is not supported
[68971.910135] ksmbd: v5 version is not supported
...

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/ndr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ksmbd/ndr.c
+++ b/fs/ksmbd/ndr.c
@@ -242,7 +242,7 @@ int ndr_decode_dos_attr(struct ndr *n, s
 		return ret;
 
 	if (da->version != 3 && da->version != 4) {
-		pr_err("v%d version is not supported\n", da->version);
+		ksmbd_debug(VFS, "v%d version is not supported\n", da->version);
 		return -EINVAL;
 	}
 
@@ -251,7 +251,7 @@ int ndr_decode_dos_attr(struct ndr *n, s
 		return ret;
 
 	if (da->version != version2) {
-		pr_err("ndr version mismatched(version: %d, version2: %d)\n",
+		ksmbd_debug(VFS, "ndr version mismatched(version: %d, version2: %d)\n",
 		       da->version, version2);
 		return -EINVAL;
 	}
@@ -457,7 +457,7 @@ int ndr_decode_v4_ntacl(struct ndr *n, s
 	if (ret)
 		return ret;
 	if (acl->version != 4) {
-		pr_err("v%d version is not supported\n", acl->version);
+		ksmbd_debug(VFS, "v%d version is not supported\n", acl->version);
 		return -EINVAL;
 	}
 
@@ -465,7 +465,7 @@ int ndr_decode_v4_ntacl(struct ndr *n, s
 	if (ret)
 		return ret;
 	if (acl->version != version2) {
-		pr_err("ndr version mismatched(version: %d, version2: %d)\n",
+		ksmbd_debug(VFS, "ndr version mismatched(version: %d, version2: %d)\n",
 		       acl->version, version2);
 		return -EINVAL;
 	}


