Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064442;
	b=VDN4TJopJ3jZsYquBCVsQ5CsEq03XrxPGJZCyLUB4upxkiovfq4WYYQ/zganLZx0Kb0Y
	 4SRMRZjdxNqRG0YB1W/D6d5xaCMW831XB8TVOG/AWwm9duTkZZQ07mIMmLDhOKAbD7Y8B
	 4WZV8ohPtdMo3UyNgZu363S1KjCfsPDB7hdfN50hSoLHCvG6gIlZTpOl4cU38EMQPqIlf
	 P4eYji6Lqe4G5M7Q3ISAdyhj4Pg8xWX+vAqoryXL1+uJvWVTcM4EYjwdAx4G/YvHaEz9f
	 RxlDVLadJ249Ih2C/N43ZQ0v7UfiEom9CRK0O6sCtoGSFlvCuC2GVZnqGkMgm03905A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WiehN63RQHjh5NbgcC1lAw2otGKfsREWXWV5tYZWMQg=;
	b=UHmXyyrBTobBtU4t0vV7vHOqrRAkIOi3M2hoY6qPY3ysngQdiFCyEaj3R8DtssfHgk3i
	 NhIHDuDwXL+W4M9sUvkSKDGAIROcdHlp+qc4oJvATzopIaLq4NVeh5rzVaFx4NoG2AKgo
	 LLSC7T/No1InmkRP4GrzJKps/+nQ4PtDx40eXc8KeVdtJRG25gfnUxe4snPplN1+er51Y
	 l/97raVBuK4usugXLkPmoa0aV5qXDNtDZxka1X+k4ilNRahAeX9Oz8EpLOyiIhtzwAkZN
	 q4tmOYB6PQd9oL3I5qr0t75gGLZIF+9twZ4wN3W8GlmGq1j08g35Xjak2JR4KXHHhOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKIhSEAS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE074606A334;
	Sat,  7 Nov 2026 15:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKIhSEAS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9A81F0089F;
	Sat,  7 Nov 2026 15:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064441;
	bh=WiehN63RQHjh5NbgcC1lAw2otGKfsREWXWV5tYZWMQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKIhSEASHfCcpPb9UyUJPIcwfntNu6SPrIhKsgeEzIg6JNCwQbhXKOXYJQPgFpQ9M
	 3D4ActqDLWGj02DtQd6gLaaDtJgA3DXvjnaUBuMoZKUCSsOiHV+08E1NBpHrPNfGZe
	 hHy50fNlOhpu0EYuT6PZ95mrDWcd5CPItqrpZkx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair@alistair23.me>,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0487/1257] PCI/DOE: Fix double free of a duplicate features sysfs name
Date: Sat,  7 Nov 2026 08:46:23 -0500
Message-ID: <20261107134952.895096428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 624ee129620a054466b6a29d98cd7a40ccc239cd ]

When a DOE feature is reported twice, sysfs_add_file_to_group() fails
with -EEXIST for the second copy and pci_doe_sysfs_feature_populate()
frees that attribute's name, but leaves the pointer in place.
pci_doe_sysfs_feature_remove() frees every name again when the device
is removed, or when a later feature fails to register, so the name is
freed twice:

  BUG: KASAN: double-free in pci_doe_sysfs_feature_remove+0x117/0x1b0
  Call Trace:
   kfree+0x11a/0x420
   pci_doe_sysfs_feature_remove+0x117/0x1b0
   pci_doe_sysfs_teardown+0x90/0xf0
   pci_remove_bus_device+0x128/0x2e0
   pci_stop_and_remove_bus_device_locked+0x1d/0x30
   remove_store+0xd2/0xf0

Clear the pointer after freeing the name.

Fixes: 2311ab1820fe ("PCI/DOE: Expose DOE features via sysfs")
Suggested-by: Alistair Francis <alistair@alistair23.me>
Assisted-by: LLM
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alistair Francis <alistair@alistair23.me>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261003102221.59894-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/doe.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/doe.c b/drivers/pci/doe.c
index ac95b1d2d9997..6b5d9ba8e9697 100644
--- a/drivers/pci/doe.c
+++ b/drivers/pci/doe.c
@@ -208,8 +208,9 @@ static int pci_doe_sysfs_feature_populate(struct pci_dev *pdev,
 				pci_warn(pdev, "Failed adding %s to sysfs group\n",
 					 attrs[i].attr.name);
 				goto fail;
-			} else
-				kfree(attrs[i].attr.name);
+			}
+			kfree(attrs[i].attr.name);
+			attrs[i].attr.name = NULL;
 		}
 	}
 
-- 
2.53.0



