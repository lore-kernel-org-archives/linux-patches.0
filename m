Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ABF35F8A5;
	Tue, 16 Dec 2025 12:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887334; cv=none; b=ZfuLh+RHymiMGO5lVszjjI+UIfjUfJEFgrFKLQRF6YuDY7N483Fk2/dQuNBUYDf43n1fZVf/zfTOSme8Mg79TU6NH7iMYpXpDvLZLL/Kuj7K8Ryl4CxWEh8qAdU3PbEvU5RCQUWzdJsSttJA9kXCytLghtGeY064UadGEaXgHPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887334; c=relaxed/simple;
	bh=s0VFVUDT//ekYxEneh0erJd+WMQFKwRjAdDu7GqewF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToQQ+8hEK89oDC1f8vsX9ds0Kaf4/a+4U/e8o5TgtTBIERxCeVekAG/we5ZKuxqzXXaltuL+zdtjvmJTVa9syG8o0aT4s01jCETHFnhYzVQZtfYdBVnLugq5QqYM6RgbFyTEcec6qx9EDXKyVfN6hZQTy2uSc2A7TzK3uXZjngg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlj7Gmja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlj7Gmja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26A4C4CEF1;
	Tue, 16 Dec 2025 12:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887334;
	bh=s0VFVUDT//ekYxEneh0erJd+WMQFKwRjAdDu7GqewF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlj7Gmjax554Nb8mP4wADTcvbKqkwPScQVZHpuCvjHpZzfRQjMt3gMnSkvLZ/0pA+
	 600ppf06/vgeVU089puXR1USARPs9dhv8ukyUvo2p6wl2FaoaRcrpAQSquaQVtNIAC
	 71jYIdGxo826Dx93F6qmOCChyTx9t+rE+U8+3Ohc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot@syzkaller.appspotmail.com,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 197/614] ns: initialize ns_list_node for initial namespaces
Date: Tue, 16 Dec 2025 12:09:24 +0100
Message-ID: <20251216111408.516043338@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 3dd50c58664e2684bd610a57bf3ab713cbb0ea91 ]

Make sure that the list is always initialized for initial namespaces.

Link: https://patch.msgid.link/20251029-work-namespace-nstree-listns-v4-8-2e6f823ebdc0@kernel.org
Fixes: 885fc8ac0a4d ("nstree: make iterator generic")
Tested-by: syzbot@syzkaller.appspotmail.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ns_common.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ns_common.h b/include/linux/ns_common.h
index 3a72c3f81eca4..71a5e28344d11 100644
--- a/include/linux/ns_common.h
+++ b/include/linux/ns_common.h
@@ -127,6 +127,7 @@ void __ns_common_free(struct ns_common *ns);
 	.ops			= to_ns_operations(&nsname),				\
 	.stashed		= NULL,							\
 	.__ns_ref		= REFCOUNT_INIT(refs),					\
+	.ns_list_node		= LIST_HEAD_INIT(nsname.ns.ns_list_node),		\
 }
 
 #define ns_common_init(__ns)                     \
-- 
2.51.0



