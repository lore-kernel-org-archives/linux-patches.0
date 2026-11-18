Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043986;
	b=2RGDN72iLG3G4W3qdyexj+maeRg2SXV2gVcpzKYq6wqasfwKRHAMh1Je9P4bP84l4DeK
	 igoRtV3yNmND6gmi1NSVHP2RFzMeM9cuKBYZQ+puEDLZZuO6dXkb9ebjX2eBLFFTlKdNP
	 HfB1lVLAThkxRAB80hO5Q2ry2Ltn9j6M5wop2WVCp9z7WT1w3hgePDLcShOeq2BUsERtP
	 XUzwEMqtve1aRzNQmMNG/S1OTPU6hzZ3hDAlzglcL0QuaFWU6amsKHJXLBBU4LR9y6OCg
	 tz/arxSThuIaDm4pUpdvbdNJ3y/TxF4a3I5NZ4eH7FB9SqAQlinwPSXKGcWcC7+JUcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EcV+xzWRqkZY5aggZf97fnFDeHmQYS8pt+4BxMy0EfI=;
	b=tUFkAMG3rVGQJ/xOQwpAn51hujqoFchCERZQQEzJCFTsTLlyaRnBVmol9AhSKQe7Kk3y
	 Rfm51eqrAPYRdUOHSoO98B+UKbB1DgeevSIN+kloBwlclPm9sQF4c6edLRGGktw/upj06
	 PHRwME6LPnxKDPe7kywkErDG/vtaO37V9/F2GfZKaxCmDl0Xtb7dDEvukHDOO9lssVkLl
	 gkNiJF5EuBaQhxO0EwQ1/Ouw8cXodU2B8l27As4IPu/QaEadF3GFTEygAv22Vq3BAjEKt
	 L/hHvD2ArDAJVs1HMDol/IA7wFzyFrrlt3SDnitiVSB0zTCCTA8DUw/ZvZLED6AotBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9lWwTdY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2B260A2621;
	Wed, 18 Nov 2026 23:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9lWwTdY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA3E1F000C4;
	Wed, 18 Nov 2026 23:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043986;
	bh=EcV+xzWRqkZY5aggZf97fnFDeHmQYS8pt+4BxMy0EfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9lWwTdYVGu8DaLXo066p4yYfCe+fGG1be1PCQ3/YZpPEPpJtSQcmBLr9z7HvzFRs
	 YkxIR2yUkwCvsHjK9MGJ+943/e78C3q65CBoqv74s7cXCZMemNsaXYaZwrXDZFBU4V
	 OTl9/NJU2B6r9SXMKMUasP8V5GwuRzNHX0mS7rt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0404/2857] path: add cleanup helper
Date: Wed, 18 Nov 2026 15:23:58 +0100
Message-ID: <20261118150215.936973721@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit ff2c570ef7eaa9ded58e7a02dd7a68874a897508 ]

Add a simple cleanup helper so we can cleanup struct path easily.
No need for any extra machinery. Avoid DEFINE_FREE() as it causes a
local copy of struct path to be used. Just rely on path_put() directly
called from a cleanup helper.

Link: https://lore.kernel.org/r/20240607-vfs-listmount-reverse-v1-2-7877a2bfa5e5@kernel.org
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: a7c1290eef60 ("configfs: pin the symlink target's dirent instead of chasing ->ci_dentry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/path.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/path.h b/include/linux/path.h
index 475225a03d0dc..ca073e70decd5 100644
--- a/include/linux/path.h
+++ b/include/linux/path.h
@@ -24,4 +24,13 @@ static inline void path_put_init(struct path *path)
 	*path = (struct path) { };
 }
 
+/*
+ * Cleanup macro for use with __free(path_put). Avoids dereference and
+ * copying @path unlike DEFINE_FREE(). path_put() will handle the empty
+ * path correctly just ensure @path is initialized:
+ *
+ * struct path path __free(path_put) = {};
+ */
+#define __free_path_put path_put
+
 #endif  /* _LINUX_PATH_H */
-- 
2.53.0



