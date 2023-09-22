Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B7645F58
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 18:38:51 +0000 (UTC)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3002F212C7E3;
	Fri, 22 Sep 2023 11:38:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3002F212C7E3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1695407922;
	bh=aL5El9c71MWrlr8MRz/X5/nVNwfU9u77bS051hju8/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lypAwHUSsfVsrLBQpkf3+tXoLg0OhMUfB07GSBYFpngHJ2dlfelrHFZLtdvqcPcfw
	 gb2jGkWx7jj7j+KFok33DCkuHAGLGwcP0MZF1UkZ+GwDk1YNhPBq92jBizu2BHWhMX
	 Q545R3c7wv5EA4M6D7VsqCjQtmPbT5E1s31Ycv6g=
From: Nuno Das Neves <nunodasneves@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org
Cc: patches@lists.linux.dev,
	mikelley@microsoft.com,
	kys@microsoft.com,
	wei.liu@kernel.org,
	gregkh@linuxfoundation.org,
	haiyangz@microsoft.com,
	decui@microsoft.com,
	apais@linux.microsoft.com,
	Tianyu.Lan@microsoft.com,
	ssengar@linux.microsoft.com,
	mukeshrathor@microsoft.com,
	stanislav.kinsburskiy@gmail.com,
	jinankjain@linux.microsoft.com,
	vkuznets@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	will@kernel.org,
	catalin.marinas@arm.com
Subject: [PATCH v3 12/15] Documentation: Reserve ioctl number for mshv driver
Date: Fri, 22 Sep 2023 11:38:32 -0700
Message-Id: <1695407915-12216-13-git-send-email-nunodasneves@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1695407915-12216-1-git-send-email-nunodasneves@linux.microsoft.com>
References: <1695407915-12216-1-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Acked-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/userspace-api/ioctl/ioctl-number.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 4ea5b837399a..71e6d23070ca 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -355,6 +355,8 @@ Code  Seq#    Include File                                           Comments
 0xB6  all    linux/fpga-dfl.h
 0xB7  all    uapi/linux/remoteproc_cdev.h                            <mailto:linux-remoteproc@vger.kernel.org>
 0xB7  all    uapi/linux/nsfs.h                                       <mailto:Andrei Vagin <avagin@openvz.org>>
+0xB8  all    uapi/linux/mshv.h                                       Microsoft Hypervisor VM management APIs
+                                                                     <mailto:linux-hyperv@vger.kernel.org>
 0xC0  00-0F  linux/usb/iowarrior.h
 0xCA  00-0F  uapi/misc/cxl.h
 0xCA  10-2F  uapi/misc/ocxl.h
-- 
2.25.1

