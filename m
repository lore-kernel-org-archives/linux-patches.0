Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064576;
	b=xAGqpWNkdFTGUFX966y8DctYHRoMeyXsgnusepXjBDS+IK96m2Xjzu7aWi9aO6x37JFz
	 0eFEjCn0udAS11ptsOuXOv/SmwEr0f3eClZAu+k0Oism/BieHB44C05Oj5bbIDUSvvC9Q
	 ciIF8lkME5LJGOqcmqxzFTwjBOdt0IhT1LEaIfhFxKh63p6Qwbcm2qxjC7pIU+FXgtSAi
	 ZD/b8lTodZKl4v1G12QE8vUJ+Fwt4//DBqc0tw40p+CiB3OgolflAW0obKJEi3GBxpU4c
	 WZ+IgAzf0lA5QyHAf3QtWgpUXZqG8z+9wzAsxJbfv/JJyytXgOW0V8q6Z+73V5OUQeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1bgzmlVdfeyT0dQXei6ikE590VvoM9I07bQVh29RY6g=;
	b=qRFhuyMXiGSoCrboIfXMUJcLi1mgAL3HxmssIABfqZrcG6ENoPTBPEdTJzdO2hcs69Ms
	 H3YMTQHljK20NEyIMahUSXapXc2C3y/vuA9WLi31/cg0/6o0AJ6v/22PqiKb/Ps0tbI5W
	 aoyRGbGSb07/pRnZKYGxLmGHL+rdfRimGzTudU6R9mrS/cA4ksM7rwBzwv1yYM2Kxp3Bi
	 vkt2WfFnNZZeu/5IKULnxrR7VczIpIVujpNg298Xyq/loS8ITtJS9qPLY+GL8p2pyUQVG
	 5z4hbpwOgsrRnBhte6wxb5e7D/Gk1+KjMdBeV6P2nlvWX+KzzZ+3h4XVvWXCk/tgbNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xw4QAoJn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7FC606D809;
	Sat,  7 Nov 2026 15:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xw4QAoJn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDFD1F0089F;
	Sat,  7 Nov 2026 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064576;
	bh=1bgzmlVdfeyT0dQXei6ikE590VvoM9I07bQVh29RY6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xw4QAoJnWdxb9XNAfOJujuKOg7ijKxdOHjU+Aj7/hNdgXyNtrRI7Kb8QrfhbSJ+yk
	 EqJqU92Rgtk6J+qvqadFzxPlbIOY6kg7ypLmRHZgVaS6vuoq7nHXtIVB4Nsdo7FwNr
	 49p4Mawa/Z4Uaw/DnIEHYnLe+oXFsC+o1ZUhSObw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Jiqian Chen <Jiqian.Chen@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0596/1257] xen-pciback: Fix pcistub_device ref leak in pcistub_get_gsi_from_sbdf()
Date: Sat,  7 Nov 2026 08:48:12 -0500
Message-ID: <20261107134955.787369213@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit cfaf31becde901f7a2376d36db628f8be0bc7283 ]

pcistub_get_gsi_from_sbdf() obtains the stub device with
pcistub_device_find(), which returns it with its kref incremented, and
returns psdev->gsi without dropping that reference again.  The caller
cannot release it either, so every lookup leaks one reference to the
stub device.

Release the reference after reading gsi.

Fixes: 2fae6bb7be32 ("xen/privcmd: Add new syscall to get gsi from dev")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jiqian Chen <Jiqian.Chen@amd.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260916171141.2086627-1-vulab@iscas.ac.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xen-pciback/pci_stub.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 79a2b5dfd6941..d1a335233aab0 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -234,13 +234,16 @@ static int pcistub_get_gsi_from_sbdf(unsigned int sbdf)
 	int bus = PCI_BUS_NUM(sbdf);
 	int slot = PCI_SLOT(sbdf);
 	int func = PCI_FUNC(sbdf);
+	int gsi;
 
 	psdev = pcistub_device_find(domain, bus, slot, func);
-
 	if (!psdev)
 		return -ENODEV;
 
-	return psdev->gsi;
+	gsi = psdev->gsi;
+	pcistub_device_put(psdev);
+
+	return gsi;
 }
 #endif
 
-- 
2.53.0



