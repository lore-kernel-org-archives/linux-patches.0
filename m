Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC706FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B481BC433D2;
	Mon, 16 Jan 2023 17:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888721;
	bh=CN1rSHWsmE5ZCg/va/GBvMz5TNql5U3zZZDj5Ugvbig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETWDU7k/YW4TIzSCX2Ao2MhPdpJVLBEKoxsQpVRvdReftVu2N4wQ0b46Hf/ic22gZ
	 bz+vkPS4e9evlkCEbA2VDAK66rvBuDqB5+OWg28sbvRuLZdkuqC/f3moyfrhfIX21f
	 xU8eqHrMsIECQKksOvdiFDYQjAYIJso6BqInW7X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 082/338] HID: hid-sensor-custom: set fixed size for custom attributes
Date: Mon, 16 Jan 2023 16:49:15 +0100
Message-Id: <20230116154824.460351038@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 9d013910df22de91333a0acc81d1dbb115bd76f6 ]

This is no bugfix (so no Fixes: tag is necessary) as it is
taken care of in hid_sensor_custom_add_attributes().

The motivation for this patch is that:
hid_sensor_custom_field.attr_name and
hid_sensor_custom_field.attrs
has the size of HID_CUSTOM_TOTAL_ATTRS and used in same context.

We compare against HID_CUSTOM_TOTAL_ATTRS when
looping through hid_custom_attrs.

We will silent the smatch error:
hid_sensor_custom_add_attributes() error: buffer overflow
'hid_custom_attrs' 8 <= 10

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sensor-custom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sensor-custom.c b/drivers/hid/hid-sensor-custom.c
index 574126b649e9..4aa8ae62155b 100644
--- a/drivers/hid/hid-sensor-custom.c
+++ b/drivers/hid/hid-sensor-custom.c
@@ -67,7 +67,7 @@ struct hid_sensor_sample {
 	u32 raw_len;
 } __packed;
 
-static struct attribute hid_custom_attrs[] = {
+static struct attribute hid_custom_attrs[HID_CUSTOM_TOTAL_ATTRS] = {
 	{.name = "name", .mode = S_IRUGO},
 	{.name = "units", .mode = S_IRUGO},
 	{.name = "unit-expo", .mode = S_IRUGO},
-- 
2.35.1



