Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB7A11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7204FC433C8;
	Mon, 11 Sep 2023 14:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444284;
	bh=Cs/4ma+C1hvAc/Qy9tZVZjsoIWDeek3jHy6+b2IOwLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crmL+GB64eigyms2j9AcEwRecMzE+h3/1uc0R27KW7Vt6hyIh05h3tro7pLvSE6BW
	 2UIHa2A+zyeYP5trd9h4jomzyvy1E3qFw40ci2ubGW/obtaxweLCxTpOl7XntnS4aB
	 3leEr0woMZd1G/AlX1pw1gC9BB5/2i9aOxWbB6zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Douglas Gilbert <dgilbert@interlog.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.4 648/737] scsi: core: Fix the scsi_set_resid() documentation
Date: Mon, 11 Sep 2023 15:48:27 +0200
Message-ID: <20230911134708.632871087@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

commit f669b8a683e4ee26fa5cafe19d71cec1786b556a upstream.

Because scsi_finish_command() subtracts the residual from the buffer
length, residual overflows must not be reported. Reflect this in the SCSI
documentation. See also commit 9237f04e12cc ("scsi: core: Fix
scsi_get/set_resid() interface")

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230721160154.874010-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/scsi/scsi_mid_low_api.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -1190,11 +1190,11 @@ Members of interest:
 		 - pointer to scsi_device object that this command is
                    associated with.
     resid
-		 - an LLD should set this signed integer to the requested
+		 - an LLD should set this unsigned integer to the requested
                    transfer length (i.e. 'request_bufflen') less the number
                    of bytes that are actually transferred. 'resid' is
                    preset to 0 so an LLD can ignore it if it cannot detect
-                   underruns (overruns should be rare). If possible an LLD
+                   underruns (overruns should not be reported). An LLD
                    should set 'resid' prior to invoking 'done'. The most
                    interesting case is data transfers from a SCSI target
                    device (e.g. READs) that underrun.


