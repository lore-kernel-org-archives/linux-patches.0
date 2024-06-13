Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1172B1428E9;
	Thu, 13 Jun 2024 12:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280288; cv=none; b=KMRZHjNV8jHnQ4lO3zS2uEFMLMEGSRMdiX6x+3Z93GoSDb9TJ8F1klQV9TwFS7kG6+Oq4EO1Db3QLotnBmehho5etvTfIeVcx0c7MxYXldElr6yNiaXPOEMlKV4LL86SRIbktRhB0wlxFAsyBFM1m2cShVbN7xgPBoWBp5nKq5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280288; c=relaxed/simple;
	bh=ODrIKstFGP+iROuBE4v3xIz/tDEhJXFdePOVJ8bZEuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKr0eCLsdP+649azicOtHi2ncoot4AEv1Pu5i4IE1kRQgzpl1/kvyHL1nW2/BBXzcnEkLtZehSMe2xSufIsMZR2n6+rO9k/SeHonhC7aCu1Umea8BR8NHgtCMJV4OlNYUEmgkWY64jzBXqbzyWyCzZUzQNPNBEpCgeaeAYAZ8Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VVXq9dw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VVXq9dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824CAC2BBFC;
	Thu, 13 Jun 2024 12:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280287;
	bh=ODrIKstFGP+iROuBE4v3xIz/tDEhJXFdePOVJ8bZEuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VVXq9dwqU0IyAkdNNXF6IKV09DAS7x+30OYz3TEGljghwPsBsyBfkqaRk0O+CEmr
	 L+U22DAchCGkkL+NOJFau1hSH/2I9XUwCoFYX93UWNiVaR7yu3XS+yC4JNKPWOI3si
	 rvkpPwuwvv0Ysiy5GDwei/J/MrYNcQNrdzdIb0g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.4 190/202] intel_th: pci: Add Meteor Lake-S CPU support
Date: Thu, 13 Jun 2024 13:34:48 +0200
Message-ID: <20240613113235.072782546@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit a4f813c3ec9d1c32bc402becd1f011b3904dd699 upstream.

Add support for the Trace Hub in Meteor Lake-S CPU.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-15-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -290,6 +290,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Meteor Lake-S CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xae24),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Raptor Lake-S */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7a26),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


