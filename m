Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87E128DBA
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcROBUN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CD3C433C7;
	Mon, 16 Oct 2023 14:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467990;
	bh=/1jEnoi0XQIJrazBkUo7fxDZ+xlzSVBde+vYAefnlgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcROBUN2gssnPZk629U6gfgqyY9B8vHOZF2DOKVMZFNTdww/7DU5CLUzkOr89aGf4
	 JGR85WR6j03Jmdu7QH/OJBKvWP6kyF4tbiYd+LAtB7oKZxigrGciQYmsQh3FPbcL23
	 v96YYjlMb/LctEbPLksQm6umxUipt7idg3pO2h+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Chandrakant Minajigi <Chandrakant.Minajigi@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.5 113/191] iio: dac: ad3552r: Correct device IDs
Date: Mon, 16 Oct 2023 10:41:38 +0200
Message-ID: <20231016084018.023246847@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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


