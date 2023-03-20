Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0A61C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 14:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF3EC433EF;
	Mon, 20 Mar 2023 14:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324282;
	bh=+Kl/ommXueNTEM+LxuqbxN5eWuPXnpCntTL30FhEThU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7TIGPE/sgJgQaLRlyni/HBoejdo3ZO0U4epGpXo+MGd53W92I6gTidPnW7TghSwN
	 x0mnE4iDmMWwuYM2IR4SX2ETuo/q9S1YoiII+XYinbXSCQp3MtgbM9lz/M2BMLtFry
	 Y3A5ZOFuHeT2t6l+dNqlWjjQlR2+PoTdTZLgW/Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	lee@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 30/30] HID: uhid: Over-ride the default maximum data buffer value with our own
Date: Mon, 20 Mar 2023 15:54:54 +0100
Message-Id: <20230320145421.379804089@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
References: <20230320145420.204894191@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lee Jones <lee@kernel.org>

commit 1c5d4221240a233df2440fe75c881465cdf8da07 upstream.

The default maximum data buffer size for this interface is UHID_DATA_MAX
(4k).  When data buffers are being processed, ensure this value is used
when ensuring the sanity, rather than a value between the user provided
value and HID_MAX_BUFFER_SIZE (16k).

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/uhid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -399,6 +399,7 @@ struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
+	.max_buffer_size = UHID_DATA_MAX,
 };
 EXPORT_SYMBOL_GPL(uhid_hid_driver);
 


