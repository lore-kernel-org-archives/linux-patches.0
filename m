Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB860BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE58C433D2;
	Tue,  7 Mar 2023 18:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213475;
	bh=GxxFSXMNTqKtNsSPRZSLW+3w8I9CBF/zqPlg4wgMPYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cV+tg4dA20BmBnooqlXqJh6uUA+0vdDgZzFvR/j5OCHzjx40ntx43um7BDn/NBcZx
	 nMGj6XJl5iPK9oQoDkOg2O7ad0k0Durvt58N+WhYfG4Ls+mgj5QK5sROnb5CbrcjBf
	 ny+HRMhvF7kfSDjVINTYgOf2/HndtjqooMhr87/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dong Chuanjian <chuanjian@nfschina.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 519/885] media: drivers/media/v4l2-core/v4l2-h264 : add detection of null pointers
Date: Tue,  7 Mar 2023 17:57:33 +0100
Message-Id: <20230307170025.021370090@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dong Chuanjian <chuanjian@nfschina.com>

[ Upstream commit be3ae7cf4326e95bb1d5413b63baabc26f4a1324 ]

When the pointer variable is judged to be null, null is returned
directly.

[hverkuil: fix two checkpatch warnings]

Signed-off-by: Dong Chuanjian <chuanjian@nfschina.com>
Acked-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Fixes: d3f756ad629b ("media: v4l2: Trace calculated p/b0/b1 initial reflist")
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-h264.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-h264.c b/drivers/media/v4l2-core/v4l2-h264.c
index 72bd64f651981..c00197d095e75 100644
--- a/drivers/media/v4l2-core/v4l2-h264.c
+++ b/drivers/media/v4l2-core/v4l2-h264.c
@@ -305,6 +305,8 @@ static const char *format_ref_list_p(const struct v4l2_h264_reflist_builder *bui
 	int n = 0, i;
 
 	*out_str = kmalloc(tmp_str_size, GFP_KERNEL);
+	if (!(*out_str))
+		return NULL;
 
 	n += snprintf(*out_str + n, tmp_str_size - n, "|");
 
@@ -343,6 +345,8 @@ static const char *format_ref_list_b(const struct v4l2_h264_reflist_builder *bui
 	int n = 0, i;
 
 	*out_str = kmalloc(tmp_str_size, GFP_KERNEL);
+	if (!(*out_str))
+		return NULL;
 
 	n += snprintf(*out_str + n, tmp_str_size - n, "|");
 
-- 
2.39.2



