Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3A81DF98F;
	Tue,  8 Oct 2024 12:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392113; cv=none; b=IarXABU2XOgAS5JSAwDxpfRPY/Si+YlpQGBvCAmF9DT6lcn0onNGL9h5Ug0HFVGLck6uSCJylYn2UzsqWT/ccWr1VglCkIrw+YslcI0GHXVzYIQPRT9h9BLe4zh47llXctiOf9HLSTMF2TXO+r9h9kGRd7YJSvThuU0UCeiqaAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392113; c=relaxed/simple;
	bh=2F6EZe1ZncIGj4DKAlIU6Pkg0xU6uKAK00GxBD2lyv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D+Oc6kCYivCDD61lIl0qyy5EOFxvzZyqyGksJpoe5f8AQzgq754WuRM6l4q3LKls/UeA0I+qaXEn2zMoFDL/MqacRMfKQAaiRAvln+NqoVt93Rs4L2fbzIzeab/vh0V5xUkBdlqlhjPp0EBtch+cwmRezD5UORKcXdww4zvpD4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOGqMQVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOGqMQVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B487C4CECD;
	Tue,  8 Oct 2024 12:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392112;
	bh=2F6EZe1ZncIGj4DKAlIU6Pkg0xU6uKAK00GxBD2lyv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOGqMQVdRaV0/t8O2orAfe6gSwamPcYdXgyNXqi0VFzW4im20H6NPp74fRoG/z6Nx
	 JYeNwMEgR4+jTubVPzRoe8SZRVSVr5lQUZu9SB9BjQKOlbBYpbvqDB1jtNbke6BTDI
	 LIYg2+v95oqnttLLwh/UKtpWFAADkxxPpOChKEhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Alessandro Zanni <alessandro.zanni87@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 320/558] kselftest/devices/probe: Fix SyntaxWarning in regex strings for Python3
Date: Tue,  8 Oct 2024 14:05:50 +0200
Message-ID: <20241008115714.900267690@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Zanni <alessandro.zanni87@gmail.com>

[ Upstream commit a19008256d05e726f29f43c6a307e45482c082c3 ]

Insert raw strings to prevent Python3 from interpreting string literals
as Unicode strings and "\d" as invalid escaped sequence.

Fix the warnings:

tools/testing/selftests/devices/probe/test_discoverable_devices.py:48:
SyntaxWarning: invalid escape sequence '\d' usb_controller_sysfs_dir =
"usb[\d]+"

tools/testing/selftests/devices/probe/test_discoverable_devices.py: 94:
SyntaxWarning: invalid escape sequence '\d' re_usb_version =
re.compile("PRODUCT=.*/(\d)/.*")

Fixes: dacf1d7a78bf ("kselftest: Add test to verify probe of devices from discoverable buses")

Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Alessandro Zanni <alessandro.zanni87@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/devices/probe/test_discoverable_devices.py      | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/devices/probe/test_discoverable_devices.py b/tools/testing/selftests/devices/probe/test_discoverable_devices.py
index d94a74b8a0548..d7a2bb91c8079 100755
--- a/tools/testing/selftests/devices/probe/test_discoverable_devices.py
+++ b/tools/testing/selftests/devices/probe/test_discoverable_devices.py
@@ -45,7 +45,7 @@ def find_pci_controller_dirs():
 
 
 def find_usb_controller_dirs():
-    usb_controller_sysfs_dir = "usb[\d]+"
+    usb_controller_sysfs_dir = r"usb[\d]+"
 
     dir_regex = re.compile(usb_controller_sysfs_dir)
     for d in os.scandir(sysfs_usb_devices):
@@ -91,7 +91,7 @@ def get_acpi_uid(sysfs_dev_dir):
 
 
 def get_usb_version(sysfs_dev_dir):
-    re_usb_version = re.compile("PRODUCT=.*/(\d)/.*")
+    re_usb_version = re.compile(r"PRODUCT=.*/(\d)/.*")
     with open(os.path.join(sysfs_dev_dir, "uevent")) as f:
         return int(re_usb_version.search(f.read()).group(1))
 
-- 
2.43.0



