Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163ED76C85;
	Wed, 21 Feb 2024 13:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521651; cv=none; b=HYBQ4c/3WZUECRdmVWLNx6uGQHSFiH3MK2C4UHeqBVdjv/fSDFj7igSBWXdmcd+MCxgPQoQ7yUDdFb6HCnkF60R3YgvnArJHSj+0FUrQYbf0UH9bc7jYL/OBZgYE65PQG4SIe1s4qzyzcRyFaLwm9V9+aMC6uM7MkjcGuFI/9oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521651; c=relaxed/simple;
	bh=f2NrzF4nzvcnaYODmp0YAgL9skWT5fcG6qSGQ2kXZHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlwumhV9XXOpO0wASB8mE5nmSPAphZeYLVujss/4e3vVi4qT5rh6q0F6mb70fHAqEV182qxFHBmG3UZS3Rw9sEHmUw2wZa5SXmnaJfe9lHGkT+/MuYnEQbESiQ5BscBO4lBya5CHZKlgOrDj31QwIu04pxdg3N+WqtzD2JEJkhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sM0VhNzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sM0VhNzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0F0C433F1;
	Wed, 21 Feb 2024 13:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521651;
	bh=f2NrzF4nzvcnaYODmp0YAgL9skWT5fcG6qSGQ2kXZHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sM0VhNzEU1kTwH7FSBnrMrRf0rJIGfhmub+HKrMXk7zmFZ570ejKa5zFqdK2rMDtA
	 +rfQxU/ZYC7YWm4RcTPuIU+VuEMengbjXsfQ+isdwPg4uBc4b8eB43dwkV2QDfhV3Q
	 TlBrWej1MPXx6wxz7VZipT3ELQCwxxvYYvvJl3yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarod Wilson <jarod@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Julian Wiedmann <jwi@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 169/202] Documentation: net-sysfs: describe missing statistics
Date: Wed, 21 Feb 2024 14:07:50 +0100
Message-ID: <20240221125937.220638328@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit e528afb72a481977456bb18345d4e7f6b85fa7b1 ]

Sync the ABI description with the interface statistics that are currently
available through sysfs.

CC: Jarod Wilson <jarod@redhat.com>
CC: Jonathan Corbet <corbet@lwn.net>
CC: linux-doc@vger.kernel.org
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5b3fbd61b9d1 ("net: sysfs: Fix /sys/class/net/<iface> path for statistics")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ABI/testing/sysfs-class-net-statistics       | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net-statistics b/Documentation/ABI/testing/sysfs-class-net-statistics
index 397118de7b5e..55db27815361 100644
--- a/Documentation/ABI/testing/sysfs-class-net-statistics
+++ b/Documentation/ABI/testing/sysfs-class-net-statistics
@@ -51,6 +51,14 @@ Description:
 		packet processing. See the network driver for the exact
 		meaning of this value.
 
+What:		/sys/class/<iface>/statistics/rx_errors
+Date:		April 2005
+KernelVersion:	2.6.12
+Contact:	netdev@vger.kernel.org
+Description:
+		Indicates the number of receive errors on this network device.
+		See the network driver for the exact meaning of this value.
+
 What:		/sys/class/<iface>/statistics/rx_fifo_errors
 Date:		April 2005
 KernelVersion:	2.6.12
@@ -88,6 +96,14 @@ Description:
 		due to lack of capacity in the receive side. See the network
 		driver for the exact meaning of this value.
 
+What:		/sys/class/<iface>/statistics/rx_nohandler
+Date:		February 2016
+KernelVersion:	4.6
+Contact:	netdev@vger.kernel.org
+Description:
+		Indicates the number of received packets that were dropped on
+		an inactive device by the network core.
+
 What:		/sys/class/<iface>/statistics/rx_over_errors
 Date:		April 2005
 KernelVersion:	2.6.12
-- 
2.43.0



