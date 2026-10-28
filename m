Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214731;
	b=0IgiUJNkorI/n4/HlfTxNrcccdVioEQw74pyWqdJLuKntdV28r2FqE3L8PSEQQPyW4eW
	 a2A39yHxcySwl4ZnHjLQYwOFTGL/LbEFwx0SoDnb/Enf9fFoZ9XbDX95BQeeLN9ZRTUKe
	 0aaJoAg7JLGS/bDTyhZgONCWzFpxrMo45L0fWeoDcCl6krQ2uh/m1wy+QluK0ivc5irlR
	 UUpw/Tr0DqZj9sdDuxfOIMhb2jRDmYAaxXvKgFZ7wF+lEa10UZd/rR7J3mo989aJ17SXx
	 Bfd2oD2L1Up44Jk8MObpnPzUFF3+ohqcRxRxwuWTlm4xKzHzOa5jOm7a+9YAnUH9a5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j7F42CH9/Gubo2jkLX0lqsGTAoOUZJaUTVjT8DdGV5Q=;
	b=E7y7IA1AxSXP+eq8yMIp3E3RyWA+HyHk5IGouzNHO95w5YFBkwryMgBSbfsd5tPoL0ZC
	 8ZtQkcCciH5Nq94QDtFAV3OYoI4pDvZ9myDK4Scaa6WLdMf8KkqmTunulEvERBWY8lkmc
	 jO+05CeW4BvHP6ppIvDcTc1XgJTKuFwxcyKtBdzdNopzG4bd3nY7MsTU6WAOjchvjOhUT
	 JFYCmKIzHiQeJZ410Kao0CSSHGjPBbXJzjwejQFzMKfzUKLXVlYXMbT8uVL7e4YGn9JKW
	 HEBrx8CQPZmsYpT6WS3KAV81mLVhlEpWuoMGEJi+kHQPq+FkGCB/CXJwuGXGbtd/now==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kwWB13sY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE46606AB31;
	Wed, 28 Oct 2026 19:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kwWB13sY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED23D1F01825;
	Wed, 28 Oct 2026 19:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214731;
	bh=j7F42CH9/Gubo2jkLX0lqsGTAoOUZJaUTVjT8DdGV5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kwWB13sYUWEHG1Umqqw5tgWGM+m8iSaWDGzS7u4rGXD1a6h7sVctd6/+oPs0fcB7Q
	 TiCcWFhlGH5LQafzFeleKTR6t8Yu04mcUSWyp90V9xkS5dFYpPxsDQeaOiDmakaaD2
	 Ks0rJgBjl66mjT262EUZVOGK3DNoiaS1vXmL1JAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0963/1887] ksmbd: validate response sizes in ipc_validate_msg()
Date: Wed, 28 Oct 2026 17:50:59 +0100
Message-ID: <20261028170521.322538788@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit d6a6aa81eac2c9bff66dc6e191179cb69a14426b ]

ipc_validate_msg() computes the expected message size for each
response type by adding (or multiplying) attacker-controlled fields
from the daemon response to a fixed struct size in unsigned int
arithmetic.  Three cases can overflow:

  KSMBD_EVENT_RPC_REQUEST:
      msg_sz = sizeof(struct ksmbd_rpc_command) + resp->payload_sz;
  KSMBD_EVENT_SHARE_CONFIG_REQUEST:
      msg_sz = sizeof(struct ksmbd_share_config_response) +
               resp->payload_sz;
  KSMBD_EVENT_LOGIN_REQUEST_EXT:
      msg_sz = sizeof(struct ksmbd_login_response_ext) +
               resp->ngroups * sizeof(gid_t);

resp->payload_sz is __u32 and resp->ngroups is __s32.  Each addition
can wrap in unsigned int; the multiplication by sizeof(gid_t) mixes
signed and size_t, so a negative ngroups is converted to SIZE_MAX
before the multiply.  A wrapped value of msg_sz that happens to
equal entry->msg_sz bypasses the size check on the next line, and
downstream consumers (smb2pdu.c:6742 memcpy using rpc_resp->payload_sz,
kmemdup in ksmbd_alloc_user using resp_ext->ngroups) then trust the
unverified length.

Use check_add_overflow() on the RPC_REQUEST and SHARE_CONFIG_REQUEST
paths to detect integer overflow without constraining functional
payload size; userspace ksmbd-tools grows NDR responses in 4096-byte
chunks for calls like NetShareEnumAll, so a hard transport cap is
unworkable on the response side.  For LOGIN_REQUEST_EXT, reject
resp->ngroups outside the signed [0, NGROUPS_MAX] range up front and
report the error from ipc_validate_msg() so it fires at the IPC
boundary; with that bound the subsequent multiplication and addition
stay well below UINT_MAX.  The now-redundant ngroups check and
pr_err in ksmbd_alloc_user() are removed.

This is the response-side analogue of aab98e2dbd64 ("ksmbd: fix
integer overflows on 32 bit systems"), which hardened the request
side.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Fixes: a77e0e02af1c ("ksmbd: add support for supplementary groups")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_ipc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 89fae5e1886ae..63d0e8bf39aa5 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -13,6 +13,7 @@
 #include <net/genetlink.h>
 #include <linux/socket.h>
 #include <linux/workqueue.h>
+#include <linux/overflow.h>
 
 #include "vfs_cache.h"
 #include "transport_ipc.h"
@@ -478,7 +479,9 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
 	if (entry->type == KSMBD_EVENT_RPC_REQUEST) {
 		struct ksmbd_rpc_command *resp = entry->response;
 
-		msg_sz = sizeof(struct ksmbd_rpc_command) + resp->payload_sz;
+		if (check_add_overflow(sizeof(struct ksmbd_rpc_command),
+				       resp->payload_sz, &msg_sz))
+			return -EINVAL;
 	} else if (entry->type == KSMBD_EVENT_SPNEGO_AUTHEN_REQUEST) {
 		struct ksmbd_spnego_authen_response *resp = entry->response;
 
-- 
2.53.0



