Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5CB7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3100AC433EF;
	Mon, 24 Apr 2023 13:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342848;
	bh=v1XyL3NmflixdwWGNBTxSEHkkwJBpp4WaNuyxfyX4Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAU58oeKTrmF88uVhAsAVtsrbqjk6hUzcIm/Q35A3tcPAIT7Ww2Fn/wY3XKzXOEOl
	 w/ixGsd5xN0zEvjknm/etUXMePGg42upbhgQ20sW4Vu10RxlPfBQFW0o1iF1hkiQYN
	 mLqeQYzlKJceL2+CPrVW6sDKk4KZcmAtT9nRqizs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Brian Masney <bmasney@redhat.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 52/98] iio: light: tsl2772: fix reading proximity-diodes from device tree
Date: Mon, 24 Apr 2023 15:17:15 +0200
Message-Id: <20230424131135.867550569@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Masney <bmasney@redhat.com>

commit b1cb00d51e361cf5af93649917d9790e1623647e upstream.

tsl2772_read_prox_diodes() will correctly parse the properties from
device tree to determine which proximity diode(s) to read from, however
it didn't actually set this value on the struct tsl2772_settings. Let's
go ahead and fix that.

Reported-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/lkml/20230327120823.1369700-1-trix@redhat.com/
Fixes: 94cd1113aaa0 ("iio: tsl2772: add support for reading proximity led settings from device tree")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20230404011455.339454-1-bmasney@redhat.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/tsl2772.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/light/tsl2772.c
+++ b/drivers/iio/light/tsl2772.c
@@ -601,6 +601,7 @@ static int tsl2772_read_prox_diodes(stru
 			return -EINVAL;
 		}
 	}
+	chip->settings.prox_diode = prox_diode_mask;
 
 	return 0;
 }


