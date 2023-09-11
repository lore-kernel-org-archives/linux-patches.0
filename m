Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE5B11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202F1C433C7;
	Mon, 11 Sep 2023 14:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443784;
	bh=vK9cmj/kVQNYttGmpe1dAbeka/bzJeZqpW92JrES1iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/jfrCZ5ch2B6ib8aD5CoIdsLbiEtG4cwbTjRc4p8mbSIB44kq+lnQaWWvBVYydzM
	 z6TK2I+uLVpo33hpHRoRcPKJ7e+fWbHwHDGIR6iDQ9JIM3P3HxnUKGw7Dy8KZMucLF
	 F8V/hahz0udFmn95Gm6jIgztlW/jKdSp9BYlglY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 500/737] media: rkvdec: increase max supported height for H.264
Date: Mon, 11 Sep 2023 15:45:59 +0200
Message-ID: <20230911134704.539066048@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit f000e6ca2d60fefd02a180a57df2c4162fa0c1b7 ]

After testing it is possible for the hardware to decode H264
bistream with a height up to 2560.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Fixes: cd33c830448ba ("media: rkvdec: Add the rkvdec driver")
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index 134e2b9fa7d9a..84a41792cb4b8 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -120,7 +120,7 @@ static const struct rkvdec_coded_fmt_desc rkvdec_coded_fmts[] = {
 			.max_width = 4096,
 			.step_width = 16,
 			.min_height = 48,
-			.max_height = 2304,
+			.max_height = 2560,
 			.step_height = 16,
 		},
 		.ctrls = &rkvdec_h264_ctrls,
-- 
2.40.1



