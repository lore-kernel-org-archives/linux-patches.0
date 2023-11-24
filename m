Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DD235F04;
	Fri, 24 Nov 2023 19:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZzXZaCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BCEC433C8;
	Fri, 24 Nov 2023 19:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853928;
	bh=oSHzqvOAh9w+vbyQMN9ryjiBhMjXYDjgpykh/9upL9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZzXZaCAhjzy3jeWjIHm9QCL9HVSsJSHdy+2r4mEfBZ1z9f3AAIu8caZTuOAPNknf
	 UqrjYQV8p4RAxSyhf+0KGtIkpPkDYt47SD4XvNR5iFa667HJYl1JfZ0opsG0BK6Yfy
	 0tr0IcgBuu9thAEtOjbbCwAyY6HclU69PHiRnRUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 086/159] mmc: vub300: fix an error code
Date: Fri, 24 Nov 2023 17:55:03 +0000
Message-ID: <20231124171945.502967061@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit b44f9da81783fda72632ef9b0d05ea3f3ca447a5 upstream.

This error path should return -EINVAL instead of success.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/0769d30c-ad80-421b-bf5d-7d6f5d85604e@moroto.mountain
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2318,6 +2318,7 @@ static int vub300_probe(struct usb_inter
 		vub300->read_only =
 			(0x0010 & vub300->system_port_status.port_flags) ? 1 : 0;
 	} else {
+		retval = -EINVAL;
 		goto error5;
 	}
 	usb_set_intfdata(interface, vub300);


