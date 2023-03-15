Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC94D4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7EFC4339B;
	Wed, 15 Mar 2023 12:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883504;
	bh=XuyHaZuG0ru7yipTj0ogoYWBoD0KKQgXfqhXjejDRiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQki1hfj4Db2DQUnLQm/Dhju96NV4HeuT8O9f8XIaMKUYpouiz0lgXyhLeXyO4WTZ
	 9lNAvN1z9m4lNo9qW+3rVygmp9Krg6Ss7NHrYW8ISrbOYW8FdE6TYMnKjdg7B8fqmd
	 85ibUTLBv8jn1hKcuvb6tCrSi3Bw7IJ+WxJHgk7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.1 024/143] HID: uhid: Over-ride the default maximum data buffer value with our own
Date: Wed, 15 Mar 2023 13:11:50 +0100
Message-Id: <20230315115741.239665256@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/uhid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -395,6 +395,7 @@ struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
+	.max_buffer_size = UHID_DATA_MAX,
 };
 EXPORT_SYMBOL_GPL(uhid_hid_driver);
 


