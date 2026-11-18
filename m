Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062228;
	b=f1EzkMQT78YQ2BaIp4cJw2f8WeAsHB46BL0MWhNpIaXFjeJHdUmObf9w/A7Z5jhiLY4J
	 I7wZTZjKVjBOyen6Gwr4RN+W21KMUPe6dg6woYJ7m4cUoKxG0wieFKEHrjUyTj1jIP1wj
	 Po7XLj9/LFOBS5jJ9Pq25NeGXsmn+8grcNgTSlwuNiiz7bjNSIZGSZwHFRm7BgYweXDMt
	 9AVCTp2LZWBspaMnPDWawTYxHC+SCua0MkXjyKZkioGUu11wHrPz7qjn7X9QK+KSV6eYO
	 o81UM6eZ2iCCchphqZLhss9XjZKxEicJaWqyIuh8ndVQCVaXWkt1Y1pMY1ps6rA0f2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/zIo5HjMv4cA61p/1cFXkOZ5JgBtTwesJS8rEGQIMHs=;
	b=mUxu6DKN/sTPfMpAoQ0QNYyvh7ivhoXfiy0HGJEcqEQTSPiUxSksDrjd8W+ycaCPjtCI
	 HjwDqzo4CXjEGsuzKJybnK6ckHgTRvzhG26UILgoWeKid4/INBp4VyQ4sVv5JFO2fadSL
	 6HxHXoeDUDwj2tJuomZObY2iIPsvzDLNiBzMKQWNVf2CFMDC3bKkvk9pmgs/uqeSSuAwx
	 ziJbNxUK3gY6K4SwMfL63wu6hj/o+pvh0+sKB/qunqtDRn0X5szVZ+wmDXDd0W7B64qrk
	 6uQNjSXndWolY9NUGl/1aBrLWJ/mqDll6B0NVKe1xq7OEE8j8zLEg/DG+JM4eaSQBcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E9IEZ5R1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B83606A325;
	Thu, 19 Nov 2026 04:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E9IEZ5R1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B271F000C4;
	Thu, 19 Nov 2026 04:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062227;
	bh=/zIo5HjMv4cA61p/1cFXkOZ5JgBtTwesJS8rEGQIMHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9IEZ5R1ZeTSSmvf8OXNRYOAQlzokSLQCuRD23Eo154WgsXBnDCaH7MuVJUlTR4+Q
	 rdwOv1ivpKRiRcNY8k3i8JCCeJDJ6g4+vtO8k6Pl88fqRwzRbHyjNWXIccnOR3Sn0H
	 Z/WMvgHhPeQR9zZYybT3VrOfrojgJZkrXd2T+zVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 1836/1848] software node: Allow node addition to already existing device
Date: Wed, 18 Nov 2026 16:04:34 +0100
Message-ID: <20261118150036.472151764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit b622b24519f5b008f6d4e20e5675eaffa8fbd87b upstream.

If the node is added to an already exiting device, the node
needs to be also linked to the device separately.

This will make sure the reference count is kept in balance
also when the node is injected to a device afterwards.

Fixes: e68d0119e328 ("software node: Introduce device_add_software_node()")
Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210414075438.64547-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/swnode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -896,6 +896,7 @@ int device_add_software_node(struct devi
 	}
 
 	set_secondary_fwnode(dev, &swnode->fwnode);
+	software_node_notify(dev, KOBJ_ADD);
 
 	return 0;
 }
@@ -932,8 +933,8 @@ int software_node_notify(struct device *
 
 	switch (action) {
 	case KOBJ_ADD:
-		ret = sysfs_create_link(&dev->kobj, &swnode->kobj,
-					"software_node");
+		ret = sysfs_create_link_nowarn(&dev->kobj, &swnode->kobj,
+					       "software_node");
 		if (ret)
 			break;
 


