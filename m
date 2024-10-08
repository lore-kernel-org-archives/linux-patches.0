Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015921E493;
	Tue,  8 Oct 2024 12:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390460; cv=none; b=GzV32QKKdlLrsa1I6p8XBoIDzL0bkK5Ako6b8S3PLCzPOadKeTVkti63MCmRqjHo7ixDNijzOXo0B1VCXUtFJCodjCpwvZ+rfP2NZmGJFqMyM2kJza5RGJlVEAvJpV3PkWoDu3xvKMuxTVnv/NRL1uUV1SXag1jFjQZw6uRapmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390460; c=relaxed/simple;
	bh=wdZKVDgmWZ40DQfU+NhUV+TEZB1VefoYdAcuZ3q7v00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qxcOgvAfl5SPgrkj4Ns7RZDCdjMD39H1Ma+INmNMbAAEy+YW8eatc5R4R5+FOLYxaOOWJjI7OdqvXwozOsHhvNl39DiRIT59voR5jHo1lK8cLcaFi+HHwwYBExQWblB9W4zTChN1v662M1DRg4ZagMDF4U/p0OW8t1F+sXCtR/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GL/8FbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GL/8FbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7149DC4CECC;
	Tue,  8 Oct 2024 12:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390459;
	bh=wdZKVDgmWZ40DQfU+NhUV+TEZB1VefoYdAcuZ3q7v00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GL/8FbXx2l99a9iqrQB8wXG8tXvqeF6wxPWKjZ2mvqasH9x3jqoz5txCUJPI62ld
	 DZdaEL4GOK7+MIcNdWPBSsFIEHc/cugVnRVX8BcxaDqf75sNFLA09c+ljqNga07HeN
	 5K411FWP8xs8zgr+TV2wnz2t36/cp2IQcdJTKkV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Alessandro Zanni <alessandro.zanni87@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 264/482] kselftest/devices/probe: Fix SyntaxWarning in regex strings for Python3
Date: Tue,  8 Oct 2024 14:05:27 +0200
Message-ID: <20241008115658.672677107@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/devices/test_discoverable_devices.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/devices/test_discoverable_devices.py b/tools/testing/selftests/devices/test_discoverable_devices.py
index fbae8deb593d5..37a58e94e7c3a 100755
--- a/tools/testing/selftests/devices/test_discoverable_devices.py
+++ b/tools/testing/selftests/devices/test_discoverable_devices.py
@@ -39,7 +39,7 @@ def find_pci_controller_dirs():
 
 
 def find_usb_controller_dirs():
-    usb_controller_sysfs_dir = "usb[\d]+"
+    usb_controller_sysfs_dir = r"usb[\d]+"
 
     dir_regex = re.compile(usb_controller_sysfs_dir)
     for d in os.scandir(sysfs_usb_devices):
@@ -69,7 +69,7 @@ def get_acpi_uid(sysfs_dev_dir):
 
 
 def get_usb_version(sysfs_dev_dir):
-    re_usb_version = re.compile("PRODUCT=.*/(\d)/.*")
+    re_usb_version = re.compile(r"PRODUCT=.*/(\d)/.*")
     with open(os.path.join(sysfs_dev_dir, "uevent")) as f:
         return int(re_usb_version.search(f.read()).group(1))
 
-- 
2.43.0



