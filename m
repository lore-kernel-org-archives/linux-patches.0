Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA23437111;
	Tue, 21 Jul 2026 21:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670252; cv=none; b=RuQpJSAosAMfLrH6onXba/YMryTs9Z5Y1GY8QE+RZ/373biM0mYA8cL8CBLSR2oNjINxe6hwy7Pb6tgP9imR1NXsrsdDLIEvxcfirpGv5YqU9nCcUQV24j8V3pmv+GCqn20QUgCPDWK0Gsri/rQcGXTzeNzomvCLaHUA4fAhRow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670252; c=relaxed/simple;
	bh=xMY6NF0muYFvYNNKzIJXOwt9Cdv6u9bsN03ufsprwjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdTYeq4gX/rigs8wvDXJMIefIXoTWvrDOjwj7cH0rIOXRp4jpIr72hguxcnmswjTVxG6+SbOa8adZK/HJxrT7OhfFobGtPXsYnO1UZCJYSZE7sQuJMjjr+cuqiNDnVi+oFi7UdpnAkVlZpeW4MciYkPfwCbqNg7f2AC7guBEtvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oj6ediCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oj6ediCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913B11F00A3A;
	Tue, 21 Jul 2026 21:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670251;
	bh=+lnjOw79U0ZhfrTzR0WyDKho5CgfU1yGj2ExNB6c59c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oj6ediCqsttuXnrPG8OhlSj6OhK3JkYlV4qmcClhRhqGovDO4/Z+SjznSGnLikSuw
	 r/ruBt8J9tsu7+K2LkEBiNDlyvEmh3wlYnUnPLKpaS7PEiw2f557msJl0jXwTibUPC
	 0U/Om+yqcGntVgVxPi8UIxKNWP4xjGajX4fxUecI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0862/1067] Input: ims-pcu - release data interface on disconnect
Date: Tue, 21 Jul 2026 17:24:23 +0200
Message-ID: <20260721152443.825616828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 441c510a649c8ddce38aa0311334ed8bb546b36c upstream.

During probe the driver claims the data interface, but it never releases
it. Release it in disconnect to avoid leaving it permanently claimed.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -2085,6 +2085,7 @@ static void ims_pcu_disconnect(struct us
 		ims_pcu_destroy_application_mode(pcu);
 
 	ims_pcu_buffers_free(pcu);
+	usb_driver_release_interface(&ims_pcu_driver, pcu->data_intf);
 	kfree(pcu);
 }
 


