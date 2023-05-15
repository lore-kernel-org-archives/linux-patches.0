Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A82E573
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEC9C433D2;
	Mon, 15 May 2023 16:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168846;
	bh=KrvR6Ikh8JsitHsXhitfnmcAniOW3nJNKSc6LKKcdCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqeuRYwAoCFuMuEJJDuW2BqiTBUKyuhD5YgXYMlyEJiaKUEG7So7En0xcG12zntga
	 /fuTuB/h8x/t11FlYb+u5xdDyzaM8RHDD2Gg2Jr88bJw2I1owSYiELwKXHz9vEMXxK
	 MGD+azwDCmnY/kxOGImFh9ZzJi4ILsyGIBXLcy+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
	Helen Koike <helen.koike@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/191] media: uapi: add MEDIA_BUS_FMT_METADATA_FIXED media bus format.
Date: Mon, 15 May 2023 18:24:29 +0200
Message-Id: <20230515161708.352910280@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit 6ad253cc3436269fc6bcff03d704c672f368da0a ]

MEDIA_BUS_FMT_METADATA_FIXED should be used when
the same driver handles both sides of the link and
the bus format is a fixed metadata format that is
not configurable from userspace.
The width and height will be set to 0 for this format.

Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Acked-by: Helen Koike <helen.koike@collabora.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: eed9496a0501 ("media: av7110: prevent underflow in write_ts_to_decoder()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/uapi/v4l/subdev-formats.rst         | 27 +++++++++++++++++++
 include/uapi/linux/media-bus-format.h         |  8 ++++++
 2 files changed, 35 insertions(+)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 8e73fcfc69000..cc2ad8af51ea0 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -7565,3 +7565,30 @@ formats.
       - 0x5001
       - Interleaved raw UYVY and JPEG image format with embedded meta-data
 	used by Samsung S3C73MX camera sensors.
+
+.. _v4l2-mbus-metadata-fmts:
+
+Metadata Formats
+^^^^^^^^^^^^^^^^
+
+This section lists all metadata formats.
+
+The following table lists the existing metadata formats.
+
+.. tabularcolumns:: |p{8.0cm}|p{1.4cm}|p{7.7cm}|
+
+.. flat-table:: Metadata formats
+    :header-rows:  1
+    :stub-columns: 0
+
+    * - Identifier
+      - Code
+      - Comments
+    * .. _MEDIA-BUS-FMT-METADATA-FIXED:
+
+      - MEDIA_BUS_FMT_METADATA_FIXED
+      - 0x7001
+      - This format should be used when the same driver handles
+	both sides of the link and the bus format is a fixed
+	metadata format that is not configurable from userspace.
+	Width and height will be set to 0 for this format.
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index d6a5a3bfe6c43..be53a8c1a2dff 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -153,4 +153,12 @@
 /* HSV - next is	0x6002 */
 #define MEDIA_BUS_FMT_AHSV8888_1X32		0x6001
 
+/*
+ * This format should be used when the same driver handles
+ * both sides of the link and the bus format is a fixed
+ * metadata format that is not configurable from userspace.
+ * Width and height will be set to 0 for this format.
+ */
+#define MEDIA_BUS_FMT_METADATA_FIXED		0x7001
+
 #endif /* __LINUX_MEDIA_BUS_FORMAT_H */
-- 
2.39.2



