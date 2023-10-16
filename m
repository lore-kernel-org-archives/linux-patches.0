Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125E31A59B
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMNV0hWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B205C433C8;
	Mon, 16 Oct 2023 09:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446862;
	bh=3UHBD3mPkT+f79QwSLE2ulqtdj5quYKp75j2PrD0Es0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMNV0hWT3zVIi21TTwMV2YTTmvRNAahavHBunSRUeCfVuuvXP8DGJRac6yADnim6r
	 J77a88hARGrMorWXasO8yM/3KvDfzXFGy9Bla6E2a0hUJ4ruNQLki0nudNL0TQBx+u
	 C19MP6zZloHtuVyOueVtT1aerATmLUJsciQXqx3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Chandrakant Minajigi <Chandrakant.Minajigi@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 083/131] iio: dac: ad3552r: Correct device IDs
Date: Mon, 16 Oct 2023 10:41:06 +0200
Message-ID: <20231016084002.121922420@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Schmitt <marcelo.schmitt1@gmail.com>

commit 9a85653ed3b9a9b7b31d95a34b64b990c3d33ca1 upstream.

Device IDs for AD3542R and AD3552R were swapped leading to unintended
collection of DAC output ranges being used for each design.
Change device ID values so they are correct for each DAC chip.

Fixes: 8f2b54824b28 ("drivers:iio:dac: Add AD3552R driver support")
Signed-off-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Reported-by: Chandrakant Minajigi <Chandrakant.Minajigi@analog.com>
Link: https://lore.kernel.org/r/011f480220799fbfabdd53896f8a2f251ad995ad.1691091324.git.marcelo.schmitt1@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad3552r.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/dac/ad3552r.c
+++ b/drivers/iio/dac/ad3552r.c
@@ -140,8 +140,8 @@ enum ad3552r_ch_vref_select {
 };
 
 enum ad3542r_id {
-	AD3542R_ID = 0x4008,
-	AD3552R_ID = 0x4009,
+	AD3542R_ID = 0x4009,
+	AD3552R_ID = 0x4008,
 };
 
 enum ad3552r_ch_output_range {


