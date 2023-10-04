Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3402D1D6A9
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBEi7gK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86BCC433C7;
	Wed,  4 Oct 2023 18:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444431;
	bh=7vXW6hslhSHyc3LIOVuD7pGSV0Ecpa54WAom6sDuX4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBEi7gK67XMQDubjYJBDg7HnjpsOoGKdoa2JsZaSzmxqjaoeoLihJTRlxf0JPC7Dx
	 y5hoBWrzBxZ/d05HSKlPSpaGzb1Kh5yA31VHHITIMCJKVJKNADqifwvOAPJknJ2dPq
	 QPmD6T9VXSTi3cRC5sMtdRw3wQzkob2L+hpzpzTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 209/321] bpf: Clarify error expectations from bpf_clone_redirect
Date: Wed,  4 Oct 2023 19:55:54 +0200
Message-ID: <20231004175238.931554756@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 7cb779a6867fea00b4209bcf6de2f178a743247d ]

Commit 151e887d8ff9 ("veth: Fixing transmit return status for dropped
packets") exposed the fact that bpf_clone_redirect is capable of
returning raw NET_XMIT_XXX return codes.

This is in the conflict with its UAPI doc which says the following:
"0 on success, or a negative error in case of failure."

Update the UAPI to reflect the fact that bpf_clone_redirect can
return positive error numbers, but don't explicitly define
their meaning.

Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230911194731.286342-1-sdf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h       | 4 +++-
 tools/include/uapi/linux/bpf.h | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 60a9d59beeabb..25f668165b567 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1897,7 +1897,9 @@ union bpf_attr {
  * 		performed again, if the helper is used in combination with
  * 		direct packet access.
  * 	Return
- * 		0 on success, or a negative error in case of failure.
+ * 		0 on success, or a negative error in case of failure. Positive
+ * 		error indicates a potential drop or congestion in the target
+ * 		device. The particular positive error codes are not defined.
  *
  * u64 bpf_get_current_pid_tgid(void)
  * 	Description
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 60a9d59beeabb..25f668165b567 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1897,7 +1897,9 @@ union bpf_attr {
  * 		performed again, if the helper is used in combination with
  * 		direct packet access.
  * 	Return
- * 		0 on success, or a negative error in case of failure.
+ * 		0 on success, or a negative error in case of failure. Positive
+ * 		error indicates a potential drop or congestion in the target
+ * 		device. The particular positive error codes are not defined.
  *
  * u64 bpf_get_current_pid_tgid(void)
  * 	Description
-- 
2.40.1



