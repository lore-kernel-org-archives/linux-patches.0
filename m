Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212135;
	b=zh3QKdDhrZN7DwNBOs3NliQOX3Q6J+vikJJb0KiEL+l8revPTPC2dx4MpkBGAPfveUw2
	 dYXCXAd2vA4HxftA6csEk06NzMqD2uD4PXxnp33GJ1MdThvxeB8A9ujvpInIObD9Ytu9e
	 5tR4mf/HM24Xe019NehqeRgHiyonI73cgoBBCL46Frin6FzgpxOVbTEkaX3T0ZEux5F4u
	 4DC8emhhPQg4o+oQ1vG/BvVQUMVQgdb/PjpRE2FCigCz6K5yLbaLWxfHeDwataAxiyeHy
	 GaCD9mlWueefO2f4g0WJbKgXd94fy8P5KZdptN6w8IIvgvrhA7rxsq3cZ2Ga7L+/e3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+iuZDGKtHsso4XYQm7evhY4sHlTq7h6cLoS9LTvEKZM=;
	b=hd7IIN6BZiU+qc9ZmxGF6rqjEtxd32+okL9S/Jx2ocJrbow995Jet6fqhXKWPyeIZ5xY
	 HpjMPeLvVLCiAoflhRIEfPgmyORxVNQam4/xXOhifaD2AQ4ZxGjWz2IaK5Rb2RukdjyFk
	 SbpHTWchVUrrPepuAYXxCe3wBYJ/HmbY0nFjseffqTyt9/aGuSYT1NVGsyBdT6CKxUicC
	 qLQp65yX1hvWqCEhf3SOCkR6N0jBQS0H8L/p/rem27hKeHzZOWzKdw2hYHlg1tq/AisQx
	 Ts6JADddrRyjLJBtK6PymHRpppTDKO2zv32RNxYHS2i586Cfhi2Gj/vL+NuG+CTXy/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0MdF0Zf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ED8606A31D;
	Wed, 28 Oct 2026 18:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0MdF0Zf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE35F1F01825;
	Wed, 28 Oct 2026 18:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212135;
	bh=+iuZDGKtHsso4XYQm7evhY4sHlTq7h6cLoS9LTvEKZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0MdF0ZfBlWm6PrjnkmKHe48T6hSQhXwpTicpYovDq9KbZFb5YNHKgAdY6FNTfAAG
	 Qg+w8LQ/fZ+ue7J2oN8Ng/JY07gsIkeYk3d1YQIkeqSu5YQdH984eidtVawEzg2849
	 YTQr5cjkD0E6F9wpIbSbkT/fli4UmOzPFTPaB25o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0049/1887] smb: client: fix heap overflow in DACL owner/group rewrite
Date: Wed, 28 Oct 2026 17:35:45 +0100
Message-ID: <20261028170500.343421136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Bjoern Doebel <doebel@amazon.de>

[ Upstream commit 0ee150794c75bcd0be0e24ff3394f433cbae18cc ]

When id_mode_to_cifs_acl rewrites an existing DACL, it allocates a
buffer sized according to the on-disk DACL length reported by
dacl_ptr->size. However, replace_sids_and_copy_aces may rewrite each
ACE with a new owner/group SID obtained from the cifs.idmap upcall.
Those SIDs can have up to SID_MAX_SUB_AUTHORITIES (15) sub-authorities,
making each ACE up to 76 bytes (sizeof(struct smb_ace)).

If the original DACL contains short SIDs (e.g., 1 sub-authority) while
the replacement SIDs are long, the rewritten ACEs overflow the
allocation.

Fix this by always budgeting for worst-case SID expansion: allocate
sizeof(struct smb_acl) plus num_aces * sizeof(struct smb_ace), which
covers the smb_acl header and room for every ACE at maximum SID size.
This replaces the previous split logic that used dacl_ptr->size for
cifsacl mounts but num_aces * sizeof(struct smb_ace) for mode_from_sid
mounts: both paths can trigger the same rewrite and need the same
headroom.

KASAN reports this as:
  BUG: KASAN: slab-out-of-bounds in build_sec_desc+0x1e8a/0x2680 [cifs]
  Write of size 4 at addr ffff8881a5e25374 by task chown/5298
  ...
  The buggy address is located 0 bytes to the right of
   allocated 884-byte region [ffff8881a5e25000, ffff8881a5e25374)

Cc: stable@vger.kernel.org
Fixes: bc3e9dd9d104 ("cifs: Change SIDs in ACEs while transferring file ownership.")
Assisted-by: Kiro:claude-opus-4.6
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Fixes: 5c3564852c58 ("cifs: Minimize the number of cifs_acl memory allocations")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ changed smb_acl/smb_ace to cifs_acl/cifs_ace and le16_to_cpu() to le32_to_cpu() for the branch’s 32-bit num_aces field. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 93e3f0bcecace..39179e639b943 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1751,11 +1751,13 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 				cifs_put_tlink(tlink);
 				return rc;
 			}
-			if (mode_from_sid)
-				nsecdesclen +=
-					le32_to_cpu(dacl_ptr->num_aces) * sizeof(struct cifs_ace);
-			else /* cifsacl */
-				nsecdesclen += le16_to_cpu(dacl_ptr->size);
+			/*
+			 * Worst case: every ACE is rewritten with a new SID of
+			 * SID_MAX_SUB_AUTHORITIES sub-auths -> sizeof(cifs_ace) each,
+			 * plus the cifs_acl header replace_sids_and_copy_aces() emits.
+			 */
+			nsecdesclen += sizeof(struct cifs_acl) +
+				le32_to_cpu(dacl_ptr->num_aces) * sizeof(struct cifs_ace);
 		}
 	}
 
-- 
2.53.0



