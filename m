Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD4D355802;
	Tue, 16 Dec 2025 12:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887188; cv=none; b=jwiN9WcKoW1VeRSFYdfp9UBE8oAl2effg4gys6OkTn9me0JWp/AXc5Vvqv5mTT55Qt2AAws6Heb1W9JumabkZ4mjaR86wPgb873sUiPrHZDvEuPINaJGUQDp0WEtudfflla1Oq9iSlhbdQ1HkKuEwyiAJ71IsmouGEKtpFtKUnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887188; c=relaxed/simple;
	bh=WNLhLZgW1VUICaf21upFeqJHToOD3fkNMp/cwCYSOqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joHjzewPGbRSs3cVL4KTPxDrYzi3zpYQWkkjG3C9KV3dLOBqDFgL77lkrYB4TGh/S5K3tJ9j8HPwH40IEAcAiadQ72rHfrW4w4M54axpnu57DyjYJCFR3LC+JBLjZi/3MKY05bh8T2n39FseGGvvzse8445S1J9L/X6v0uReet8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkSIAm7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkSIAm7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55CEC4CEF1;
	Tue, 16 Dec 2025 12:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887188;
	bh=WNLhLZgW1VUICaf21upFeqJHToOD3fkNMp/cwCYSOqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkSIAm7rlhKElJsW6J42ZQndJ3/NktJRA3GpU2Ggv4N2NiFiO2GUZfb8ZLbCTYPK+
	 McvOKLm8xVhGe47xwqtdvpyIAQPbOVGvnjgv8aHJrl4uuJrDBZe9h/u5ukW+seHLD4
	 57JCZxdGEIbLslkEdBi00pcwlv823vMf1zwwyhrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 153/614] pidfs: add missing PIDFD_INFO_SIZE_VER1
Date: Tue, 16 Dec 2025 12:08:40 +0100
Message-ID: <20251216111406.878228230@linuxfoundation.org>
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

[ Upstream commit 4061c43a99772c66c378cfacaa71550ab3b35909 ]

We grew struct pidfd_info not too long ago.

Link: https://patch.msgid.link/20251028-work-coredump-signal-v1-3-ca449b7b7aa0@kernel.org
Fixes: 1d8db6fd698d ("pidfs, coredump: add PIDFD_INFO_COREDUMP")
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/pidfd.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/pidfd.h b/include/uapi/linux/pidfd.h
index 957db425d459a..6ccbabd9a68d8 100644
--- a/include/uapi/linux/pidfd.h
+++ b/include/uapi/linux/pidfd.h
@@ -28,6 +28,7 @@
 #define PIDFD_INFO_COREDUMP		(1UL << 4) /* Only returned if requested. */
 
 #define PIDFD_INFO_SIZE_VER0		64 /* sizeof first published struct */
+#define PIDFD_INFO_SIZE_VER1		72 /* sizeof second published struct */
 
 /*
  * Values for @coredump_mask in pidfd_info.
-- 
2.51.0



