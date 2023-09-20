Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C5A3F4D5
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 23:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=tlgdA+9zRCeEqqQqdnsCAMTZo8+aT2RUqSoMURIS/L0=; b=gZWIxfyxxYZn8qx/ODs6UihV7w
	yCc0UiMKZgKV21JT2OoezTRYQ6ZGJcTL+LjYU5Kl/ydpycLgWmI0rN9OxmzJ0tDrNFETenW0qyjAZ
	jZcuflWPs1JomA/GzhSRDQjsMUOOk4z+gYkPVnUKU8pcav2geuBrihQwvqfcwFuJeC/FqrHCdIOGa
	RgflSoRRiawgM6syJ0tqe9jN/M961ZNwsACj5a4lzDKQPBdWfDf/FHcRqpKY6e5OEA2jBFyQFLQkO
	QUCkB3MRGO3k5nPhIwYDYBdShihgvRvYDf0SO0+mbkfbGdPh0ZXroFXiWk9OQFHuS2fEAoJtTecGO
	cWI7OljA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qj6xb-004UYT-1u;
	Wed, 20 Sep 2023 23:50:23 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: alx@kernel.org,
	linux-man@vger.kernel.org,
	linux-api@vger.kernel.org
Cc: hughd@google.com,
	p.raghav@samsung.com,
	da.gomez@samsung.com,
	rohan.puri@samsung.com,
	rpuri.linux@gmail.com,
	a.manzanares@samsung.com,
	dave@stgolabs.net,
	yosryahmed@google.com,
	keescook@chromium.org,
	mcgrof@kernel.org,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] tmpfs.5: extend with new noswap documentation
Date: Wed, 20 Sep 2023 16:50:22 -0700
Message-Id: <20230920235022.1070752-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Linux commit 2c6efe9cf2d7 ("shmem: add support to ignore swap")
merged as of v6.4 added support to disable swap for tmpfs mounts.

This extends the man page to document that.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

changes on v2:

 - Use semantic newlines

 man5/tmpfs.5 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man5/tmpfs.5 b/man5/tmpfs.5
index 5274e632d6fd..047a17a78ee0 100644
--- a/man5/tmpfs.5
+++ b/man5/tmpfs.5
@@ -103,6 +103,12 @@ suffixes like
 .BR size ,
 but not a % suffix.
 .TP
+.BR noswap "(since Linux 6.4)"
+.\" commit 2c6efe9cf2d7841b75fe38ed1adbd41a90f51ba0
+Disables swap.
+Remounts must respect the original settings.
+By default swap is enabled.
+.TP
 .BR mode "=\fImode\fP"
 Set initial permissions of the root directory.
 .TP
-- 
2.39.2

