Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F083419D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+i0b08e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAC3C433C8;
	Mon,  9 Oct 2023 13:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859579;
	bh=Ea/Q146n3WDinjUjPWuwaOUeg2wR4ALlpr7u5zE162M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+i0b08ehj6KyNNSIiRhk5sC8RYcVyRd1gi+BuXodOeQWvQFCDwg1yMrhyIUW9jKm
	 mNpEXXrBzcUap8e4pSIB1dlew3w0GgQ60ehuoLVvoANeP7puIm3qtlUejDj3r8yHHj
	 VAL2VNE9PLSgYjgIYzqICdsmXW/X/Br+GjpPrIzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/91] bpf: Clarify error expectations from bpf_clone_redirect
Date: Mon,  9 Oct 2023 15:06:11 +0200
Message-ID: <20231009130112.878726875@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6334aede67fc2..91c43f3756123 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -693,7 +693,9 @@ union bpf_attr {
  * 		performed again, if the helper is used in combination with
  * 		direct packet access.
  * 	Return
- * 		0 on success, or a negative error in case of failure.
+ * 		0 on success, or a negative error in case of failure. Positive
+ * 		error indicates a potential drop or congestion in the target
+ * 		device. The particular positive error codes are not defined.
  *
  * u64 bpf_get_current_pid_tgid(void)
  * 	Return
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0c30ab898e2a5..37259bae15010 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -691,7 +691,9 @@ union bpf_attr {
  * 		performed again, if the helper is used in combination with
  * 		direct packet access.
  * 	Return
- * 		0 on success, or a negative error in case of failure.
+ * 		0 on success, or a negative error in case of failure. Positive
+ * 		error indicates a potential drop or congestion in the target
+ * 		device. The particular positive error codes are not defined.
  *
  * u64 bpf_get_current_pid_tgid(void)
  * 	Return
-- 
2.40.1



