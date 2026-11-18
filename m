Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019467;
	b=KrLU4CL3mUv/yNtl920Ty5VQ6ZnxLMU44FmA0OzLAskXEJiLKHeeYSbvUk0uI9efwi3I
	 csFl3eWAwPHkG8AprVeky+hMJaiYzMNJXyoYzu0DYGTMi5io95QIjhLxCY4+xydN8IGbm
	 x1kJKq1+CnL5bs7j0Epk0W1bYqkuPJZCZbIqh5TQ8WtY2SLha6XdSW/BZdcqowiGsSRz9
	 DWQgeEjrSUP+47supeHE4HuRZkZw4U4SqT69d1UMwLnJrozdCWkrVGhF9InRn73ebEQs6
	 eT6gkpy2Vx5OafLj4KXQl5ojeKbyO/5aCqH/1ZMhTXLff7f/bKcKsjUXLfycMw6ii/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eayJHqeLiY5TQtBUiSyV2AAdkYk3af3l1UpAIUZfU8w=;
	b=A4yEs+GJv7lJ8caW50SV54wKPUXtQi42vfyf2rwnX1PZZEjIRtKPT+q35iCHzi0zSB6I
	 diBqMXQ9AqjQd2gED8PhXw82RTCVkhP5L2atXnZj9ihz8oqSmt4wCesG6VW3wzt7Wc95Z
	 hbp8WcDkmp/xmwyjuoYYspy1Jn6jugLVGyxknhRxTDScwMF0ClcFxvg84by5olmr2bsQX
	 zZeKJ3ylIwR9TTM4v28he3DS2y5TtPh2PuFr/iXKzvB2tHzNx4d/y4IQmsJf54b0kpwYR
	 mJtjQugXgeo6VPt1iE7l1D/9PiSq8IBeVann5Fkzi5paQxtYYyNds788d4XEnMhg4Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SSyeEd+v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4A2606A7C9;
	Wed, 18 Nov 2026 16:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SSyeEd+v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE4C1F000C9;
	Wed, 18 Nov 2026 16:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019466;
	bh=eayJHqeLiY5TQtBUiSyV2AAdkYk3af3l1UpAIUZfU8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSyeEd+vMAAohM+/fMA4WQWtUC9SYgqovviLo/Dovd7fhK03lS7VH3SboDM2WiWV+
	 VTdWEWPliQxrOGF1Q5wrTyRRVyqMMJgVXDyx2Qn/gp3dprAa41+MnQ0qSbusM2x5Ii
	 24npnVS3xI6zAkhQytcMre+kF+YEf5ngU1iBYgUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Swark Yang <syang@axiado.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1605/2651] mailbox: axiado: fix debugfs name truncation warning
Date: Wed, 18 Nov 2026 15:47:25 +0100
Message-ID: <20261118150345.618002364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Swark Yang <syang@axiado.com>

[ Upstream commit 5cefa9bc518f187106c6bba4600e5c6dd61de91f ]

kernel test robot reported a format-truncation warning for the
snprintf() that builds each channel's debugfs entry name:

  drivers/mailbox/axiado-mailbox.c:325:39: warning: '-errors'
  directive output may be truncated writing 7 bytes into a region
  of size between 2 and 11 [-Wformat-truncation=]

AX3005 exposes 16 mailbox channels, so the longest name generated at
runtime is "chan15-errors" and already fits in the original buffer.
However, the compiler cannot infer that bound from
drv_data->num_chans and therefore assumes the unsigned channel index
may require up to 10 decimal digits. Widen the buffer to 32 bytes,
which removes the -Wformat-truncation warning with no functional
change.

Fixes: 14af7a96afa3 ("mailbox: add Axiado AX3005 mailbox driver")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608250447.gGkRwNAl-lkp@intel.com/
Signed-off-by: Swark Yang <syang@axiado.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/axiado-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/axiado-mailbox.c b/drivers/mailbox/axiado-mailbox.c
index aa1dcc1b267d7..a87693c639dcf 100644
--- a/drivers/mailbox/axiado-mailbox.c
+++ b/drivers/mailbox/axiado-mailbox.c
@@ -379,7 +379,7 @@ static int axiado_mbox_probe(struct platform_device *pdev)
 		return ret;
 
 	for (i = 0; i < drv_data->num_chans; i++) {
-		char name[16];
+		char name[32];
 
 		ch_data[i].channel_num = i;
 		ch_data[i].chan = &mb->mbox.chans[i];
-- 
2.53.0



