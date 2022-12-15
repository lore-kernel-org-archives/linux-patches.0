Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1E4569B
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 18:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07525C433EF;
	Thu, 15 Dec 2022 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671128001;
	bh=sCd/RpVzTHWfscuq/JRkDn0LnaDIzYEJDSh6sNXPh1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VOh48YTG3ocGZMOXQqvqy/jSDaq1+dn+0ELcu4rm/BNscgkbt2UNKZSRgYcXqiau
	 WovMTqPe2RA5ZCm1mCCCINpzjA7YbzmSw3h+58wru5gAaIy9OfbrSeymKEVNWUAZIT
	 EGJ+QMwrVEQ5VziuZgKnIcQUfk4kIecjJ4mBgAf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.0 05/16] rtc: cmos: fix build on non-ACPI platforms
Date: Thu, 15 Dec 2022 19:10:49 +0100
Message-Id: <20221215172908.379253879@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
References: <20221215172908.162858817@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

commit db4e955ae333567dea02822624106c0b96a2f84f upstream.

Now that rtc_wake_setup is called outside of cmos_wake_setup, it also need
to be defined on non-ACPI platforms.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20221018203512.2532407-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-cmos.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1346,6 +1346,9 @@ static void cmos_check_acpi_rtc_status(s
 {
 }
 
+static void rtc_wake_setup(struct device *dev)
+{
+}
 #endif
 
 #ifdef	CONFIG_PNP


