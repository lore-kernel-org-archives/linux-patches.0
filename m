Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484FA33F5BE;
	Thu,  2 Jul 2026 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010670; cv=none; b=PjgE1r1RpnqVzhZ+awoB63NwGSbEGBWkYFfu91uWwSkNio12KezgMbPu2i4OHRZSOPN5bMALb6aCHpTrTFYZEwLHDYAW3rThV3EWmU71bd25VvVBgWiDIv8VIU88W6uAJlrzWHHdo5p0xftasurgbC2wnVgjgG0bhflx54Jlabk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010670; c=relaxed/simple;
	bh=ElRTYFnRac5fCzFFRuNzkVNtioJL4tIrTP9JL5ohkhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWzYegNDMKj31RbG4pP27lwfPNfJ0Pu2u9TS55DCQSekGKI48xQMqM4Cvwe5JWAGr1EEr/Jic2JR93cd1E3ObDTJ9aU/q7E18ZpDjrasZPYx56sviki2z+JjCuaxB7Bqa0zV8MCZ7OTdJ0+T8LPIssTeYo+7YVGxckNjPXaZl+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NahgDhm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NahgDhm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C83B1F00A3A;
	Thu,  2 Jul 2026 16:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010668;
	bh=Uldq758bYcPN+EdT8cQEXKblabrWTa/i9bItUqroedA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NahgDhm3/FafeIUzK5q9KOX8Bz29oDKMuAx20Fd0ADLQwxRYmplAUllCjszE9o8x6
	 5cu0YPq7AdjDO5sbS0LJd9Nl4izn+/zfCJ/ozP5+lrVLsgO9FgcRcJJOCqHNs4ADM8
	 ARgohfLly9QbpNJW0rmbKaVAMBA1KMdW1mpdtLw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haren Myneni <haren@linux.ibm.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/204] Documentation: ioctl-number: Fix linuxppc-dev mailto link
Date: Thu,  2 Jul 2026 18:20:52 +0200
Message-ID: <20260702155122.745538097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit 3dfa97bd93614c15418ba7b5c727f6c5bb617174 ]

Spell out full Linux PPC mailing list address like other subsystem
mailing lists listed in the table.

Reviewed-by: Haren Myneni <haren@linux.ibm.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20250714015711.14525-2-bagasdotme@gmail.com
Stable-dep-of: d237230728c5 ("crypto: qat - remove unused character device and IOCTLs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/userspace-api/ioctl/ioctl-number.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -358,9 +358,9 @@ Code  Seq#    Include File
 0xB1  00-1F                                                          PPPoX
                                                                      <mailto:mostrows@styx.uwaterloo.ca>
 0xB2  00     arch/powerpc/include/uapi/asm/papr-vpd.h                powerpc/pseries VPD API
-                                                                     <mailto:linuxppc-dev>
+                                                                     <mailto:linuxppc-dev@lists.ozlabs.org>
 0xB2  01-02  arch/powerpc/include/uapi/asm/papr-sysparm.h            powerpc/pseries system parameter API
-                                                                     <mailto:linuxppc-dev>
+                                                                     <mailto:linuxppc-dev@lists.ozlabs.org>
 0xB3  00     linux/mmc/ioctl.h
 0xB4  00-0F  linux/gpio.h                                            <mailto:linux-gpio@vger.kernel.org>
 0xB5  00-0F  uapi/linux/rpmsg.h                                      <mailto:linux-remoteproc@vger.kernel.org>


