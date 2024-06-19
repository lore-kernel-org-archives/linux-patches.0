Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3491412FB31;
	Wed, 19 Jun 2024 13:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802606; cv=none; b=Y73kNnRY68VH5nAB2wuO/91qpxLbCkviUzIOK1O6x9X4mUesWv/Rnzp4mqMYVbQDGRdm2hhuFmVt+sKK+qNoqqr97xdWdZDzj3xUvvxE6L7qgKgEI+KBGi9fU8/tVB+4JuiTp3u1DVcbBkfVjJoG3EbXBm6mju0FNEFKIlujec8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802606; c=relaxed/simple;
	bh=jSdO+0VraM3TjAoF+RM8Ouv5CK3CK8wElFToAY7nvSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ch16hmVhbe5WTPL88yu8X/7Omw28uTPyA28P887XIg8zWUs28tYx6UC0vp/A5Ky2rNk7y3GaVpKGaEgT26UnWw6ePreH0PdrYNnBqD48GwymKfYtdPJ93Lsppx/sqaYEnAEjczObNlU5U/p4QqAyeOG1wJ6a/oPSRbss+9SjosQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nf83OF1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nf83OF1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17A1C2BBFC;
	Wed, 19 Jun 2024 13:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802606;
	bh=jSdO+0VraM3TjAoF+RM8Ouv5CK3CK8wElFToAY7nvSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nf83OF1LmSXqveqG9gRjPElRffHShtUjwm+LWSoLk9y8AZSbQF2YaqsNeZYjHt5wx
	 7LzbMZEwVVJholQ7k4W5HhBB3X8ycAphxAyT+ZgQo3NE7zuS03H4yKZwwVOO+qGdFd
	 KD26xYHH6BUnqqgnxSAcNi3j/0huK2d+BNIuMJzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.6 222/267] intel_th: pci: Add Meteor Lake-S support
Date: Wed, 19 Jun 2024 14:56:13 +0200
Message-ID: <20240619125614.846500149@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit c4a30def564d75e84718b059d1a62cc79b137cf9 upstream.

Add support for the Trace Hub in Meteor Lake-S.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-14-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -295,6 +295,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Meteor Lake-S */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7f26),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Raptor Lake-S */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7a26),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


