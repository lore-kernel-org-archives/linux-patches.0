Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205D8361
	for <patches@lists.linux.dev>; Mon, 16 May 2022 00:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=cRM5nzf2yQfBssriQwtZcJd3iJWP9AWWeNnq/DkjfdE=; b=wSop+YtN5Ru4CUciERcosZKQ30
	JMt33+lyWqqm4GWSvE/CGM5pmVvMwTOZ1xOji8s22ZLLicu91LwUeZPKj2ikdIZNDShiU5vKitdoA
	I+QQnO6AvpjE0lYPe5ZYwBtOpRIl2jWADqTQB9YH6WALA0f2HyaUjwWnZ3YdNVHvlKvdVWw2NFKw2
	Uoi/mzROcatQLu200/Z3VzC3P/HQKm7n+oUbpq/wVqQs6Tg12NKhJpchLCftP1gtXgIkMsSitP8t6
	UJpuMFVMeCkFIET/pbEXC8x1gfgAwS0uNHZ5lFAGrdL3ludU+oIGftztQTfWgB4NApwqXGrAKTYxJ
	hawROr1g==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nqOTg-005Mvg-VG; Mon, 16 May 2022 00:20:49 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] input: Docs: correct ntrig.rst typo
Date: Sun, 15 May 2022 17:20:47 -0700
Message-Id: <20220516002047.11395-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a typo in ntrig.rst (found with 'codespell').

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/input/devices/ntrig.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/input/devices/ntrig.rst
+++ b/Documentation/input/devices/ntrig.rst
@@ -32,7 +32,7 @@ The following parameters are used to con
 |activation_height,	|size threshold to activate immediately		      |
 |activation_width	|						      |
 +-----------------------+-----------------------------------------------------+
-|min_height,		|size threshold bellow which fingers are ignored      |
+|min_height,		|size threshold below which fingers are ignored       |
 |min_width		|both to decide activation and during activity	      |
 +-----------------------+-----------------------------------------------------+
 |deactivate_slack	|the number of "no contact" frames to ignore before   |
