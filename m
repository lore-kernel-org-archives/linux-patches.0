Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EB78F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA56C433C7;
	Sun, 16 Jul 2023 20:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538772;
	bh=S32nE7NR3sK9NUGZKr7mi1U7Q1i3TDvSZ4Ee6EvLTGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnAwOWb7YQDdDrQO4U3P0dtpZikOgZ+lsx+NKJ4XR1CKMLrlNf++TF47ix9GHk5v0
	 zDj4FwmM6d8Ww+fegjfl7gCUuSgopNd06DXYA03xVTI5+qWOQYhEJqqXk/Xu1P3FaM
	 Ta9x7PPDeqIoaLgLsjOqqSmiqxGOzUy08uXriWuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 571/800] media: videodev2.h: Fix struct v4l2_input tuner index comment
Date: Sun, 16 Jul 2023 21:47:04 +0200
Message-ID: <20230716195002.349174660@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 26ae58f65e64fa7ba61d64bae752e59e08380c6a ]

VIDIOC_ENUMINPUT documentation describes the tuner field of
struct v4l2_input as index:

Documentation/userspace-api/media/v4l/vidioc-enuminput.rst
"
* - __u32
  - ``tuner``
  - Capture devices can have zero or more tuners (RF demodulators).
    When the ``type`` is set to ``V4L2_INPUT_TYPE_TUNER`` this is an
    RF connector and this field identifies the tuner. It corresponds
    to struct :c:type:`v4l2_tuner` field ``index``. For
    details on tuners see :ref:`tuner`.
"

Drivers I could find also use the 'tuner' field as an index, e.g.:
drivers/media/pci/bt8xx/bttv-driver.c bttv_enum_input()
drivers/media/usb/go7007/go7007-v4l2.c vidioc_enum_input()

However, the UAPI comment claims this field is 'enum v4l2_tuner_type':
include/uapi/linux/videodev2.h

This field being 'enum v4l2_tuner_type' is unlikely as it seems to be
never used that way in drivers, and documentation confirms it. It seem
this comment got in accidentally in the commit which this patch fixes.
Fix the UAPI comment to stop confusion.

This was pointed out by Dmitry while reviewing VIDIOC_ENUMINPUT
support for strace.

Fixes: 6016af82eafc ("[media] v4l2: use __u32 rather than enums in ioctl() structs")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/videodev2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 9e7cf1d369456..5d8bd754c69f1 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1720,7 +1720,7 @@ struct v4l2_input {
 	__u8	     name[32];		/*  Label */
 	__u32	     type;		/*  Type of input */
 	__u32	     audioset;		/*  Associated audios (bitfield) */
-	__u32        tuner;             /*  enum v4l2_tuner_type */
+	__u32        tuner;             /*  Tuner index */
 	v4l2_std_id  std;
 	__u32	     status;
 	__u32	     capabilities;
-- 
2.39.2



