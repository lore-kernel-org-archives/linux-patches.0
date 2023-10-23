Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C04B14A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkDfXB0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AEEC433C8;
	Mon, 23 Oct 2023 11:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059109;
	bh=lbwn1lhoJdGnjAKY1VSeimgfGsCwIsiRcCZeMVzonVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkDfXB0YLHKSKQzDAtJ42c4qZ7Hrdm7fvHXqfvd2ynx12JNxBC8ZzmSlT0n8IBJGl
	 0Ley/SHIh9fOB9yPHjJycKH35EE4TnB80GqWCMzNcjEhpQY7IaE9nP3Y+sujCD1HC+
	 LRY6F0kI10PmPlUwhqYJjL8QiMfIhwG/VOnf6oIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.5 067/241] docs: fix info about representor identification
Date: Mon, 23 Oct 2023 12:54:13 +0200
Message-ID: <20231023104835.535781379@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

From: Mateusz Polchlopek <mateusz.polchlopek@intel.com>

commit a258c804aa8742763dce694b5e992d7ccf4294f2 upstream.

Update the "How are representors identified?" documentation
subchapter. For newer kernels driver should use
SET_NETDEV_DEVLINK_PORT instead of ndo_get_devlink_port()
callback.

Fixes: 7712b3e966ea ("Merge branch 'net-fix-netdev-to-devlink_port-linkage-and-expose-to-user'")
Signed-off-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://lore.kernel.org/r/20231012123144.15768-1-mateusz.polchlopek@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/representors.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/representors.rst b/Documentation/networking/representors.rst
index ee1f5cd54496..decb39c19b9e 100644
--- a/Documentation/networking/representors.rst
+++ b/Documentation/networking/representors.rst
@@ -162,9 +162,11 @@ How are representors identified?
 The representor netdevice should *not* directly refer to a PCIe device (e.g.
 through ``net_dev->dev.parent`` / ``SET_NETDEV_DEV()``), either of the
 representee or of the switchdev function.
-Instead, it should implement the ``ndo_get_devlink_port()`` netdevice op, which
-the kernel uses to provide the ``phys_switch_id`` and ``phys_port_name`` sysfs
-nodes.  (Some legacy drivers implement ``ndo_get_port_parent_id()`` and
+Instead, the driver should use the ``SET_NETDEV_DEVLINK_PORT`` macro to
+assign a devlink port instance to the netdevice before registering the
+netdevice; the kernel uses the devlink port to provide the ``phys_switch_id``
+and ``phys_port_name`` sysfs nodes.
+(Some legacy drivers implement ``ndo_get_port_parent_id()`` and
 ``ndo_get_phys_port_name()`` directly, but this is deprecated.)  See
 :ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>` for the
 details of this API.
-- 
2.42.0



