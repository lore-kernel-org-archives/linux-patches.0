Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01449327797;
	Tue, 26 Aug 2025 11:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207844; cv=none; b=rUS0rhIxgHLNUeK2db4CkLvznazz1FfmZE4FdWhvIyugJigON187D3caJIB5yAOXgGBQujjH1nLXo0ZgXIIAjjd3j6F8QbU8sYj5RHc1/lyZ27FZf/eHOwDWeJpV0ZqtM6HOWw/rC30o6pNVkA2mvfopmqhDLanXZYLUbf8cRBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207844; c=relaxed/simple;
	bh=hHDZ1++XPEfZZllGYDpwwcFSAjkEhWRhG+l3hBOW3ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bkuw3LjUOPbNbneMxC+MiYwd3hFMFUkKWEPxDBYz5jmMT1BiCM+YWExPrIQOBYRK0MBR6fbInGfjYUGKKZKBjB4UuHhj/LfUacYJIsVEhJ7vrvnw7vMckIGsqprQBs4X/ngS5j6ONJAAoFxUGcajif5QQ7A5Q5zF9cSTqk87ZSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZkbSAy9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZkbSAy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F5AC4CEF1;
	Tue, 26 Aug 2025 11:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207843;
	bh=hHDZ1++XPEfZZllGYDpwwcFSAjkEhWRhG+l3hBOW3ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZkbSAy9L78011o54gDOlt+PGn8C+rS2bSFdUS4GmtSwQ0guzjsdaVyLR6cu77ymK
	 VScrGn+z2o1KksB61VhbUGD9uttNTnWfgnQlGelST0Hk1QK7ESjiGs47XJfW8L1f2Y
	 wWbmKbskLspVvgLpBpoacxYTuAhxahzlgaq/AwV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	David Kaplan <David.Kaplan@amd.com>,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Calvin Owens <calvin@wbinvd.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.16 338/457] ixgbe: prevent from unwanted interface name changes
Date: Tue, 26 Aug 2025 13:10:22 +0200
Message-ID: <20250826110945.684042953@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ upstream commit e67a0bc3ed4fd8ee1697cb6d937e2b294ec13b5e ]

Users of the ixgbe driver report that after adding devlink support by
the commit a0285236ab93 ("ixgbe: add initial devlink support") their
configs got broken due to unwanted changes of interface names. It's
caused by automatic phys_port_name generation during devlink port
initialization flow.

To prevent from that set no_phys_port_name flag for ixgbe devlink ports.

Reported-by: David Howells <dhowells@redhat.com>
Closes: https://lore.kernel.org/netdev/3452224.1745518016@warthog.procyon.org.uk/
Reported-by: David Kaplan <David.Kaplan@amd.com>
Closes: https://lore.kernel.org/netdev/LV3PR12MB92658474624CCF60220157199470A@LV3PR12MB9265.namprd12.prod.outlook.com/
Fixes: a0285236ab93 ("ixgbe: add initial devlink support")
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: stable@vger.kernel.org # 6.16
Tested-By: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/devlink/devlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/intel/ixgbe/devlink/devlink.c
+++ b/drivers/net/ethernet/intel/ixgbe/devlink/devlink.c
@@ -543,6 +543,7 @@ int ixgbe_devlink_register_port(struct i
 
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = adapter->hw.bus.func;
+	attrs.no_phys_port_name = 1;
 	ixgbe_devlink_set_switch_id(adapter, &attrs.switch_id);
 
 	devlink_port_attrs_set(devlink_port, &attrs);


