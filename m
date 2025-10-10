Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE012F3C32;
	Fri, 10 Oct 2025 13:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102308; cv=none; b=VzkJCZZWdysI6SOXj4RsQhOoVZtwNQ7xTH/6wBii+iowloum60ogRcZvrt5PE0LLmI7WDv1GzLCQU6+3kTCo2E3NUwEc7aDCHmz+6Ps0/fSO6eeeQINWHCq1A5Pc8Jnlv7Br1WbmCbdjBFVFeCC3DjY4lnC6hSounUXviHkcqRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102308; c=relaxed/simple;
	bh=WnimUu7lnCJB/a0i3CdgTCbSJbC2nStmiVvXxXGnYFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDmF6jb4pCH5cTjIfLexNDa4AOxHPwBSwFne9pp1jse6UrNv4TUdHdd1RtGX8pOl1tnlsMJvwk6M52T3SLHDaO6qrhqY41gi4Pzj38j7fsUscvnUb4sHubHGJ/in85mU4YyR9nsng8VFKGubMvH98pVERAxVs07OagVSEuJijv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLY72Yjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLY72Yjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1C1C4CEF1;
	Fri, 10 Oct 2025 13:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102307;
	bh=WnimUu7lnCJB/a0i3CdgTCbSJbC2nStmiVvXxXGnYFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLY72YjmG0XieJO5VHHvR5LoSR/6wb9sP3WDIx9xrFbY/z2k49aGclBbXSXDyokiu
	 64A90cSPOxpSz4coKAPMKxgWam5rS/izovaWFdGH6Uw/ZgRhKVM8YOhEAbt6k5zTZS
	 xcUWEBZ5dhbNetoxyFpdrb2v+hfD/SqgUTIOAp+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Rahul Rameshbabu <sergeantsagara@protonmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.16 11/41] rust: pci: fix incorrect platform reference in PCI driver probe doc comment
Date: Fri, 10 Oct 2025 15:15:59 +0200
Message-ID: <20251010131333.832567923@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <sergeantsagara@protonmail.com>

commit 855318e7c0c4a3e3014c0469dd5bc93a1c0df30c upstream.

Substitute 'platform' with 'pci'.

Fixes: 1bd8b6b2c5d3 ("rust: pci: add basic PCI device / driver abstractions")
Cc: stable@kernel.org
Signed-off-by: Rahul Rameshbabu <sergeantsagara@protonmail.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/pci.rs |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/rust/kernel/pci.rs
+++ b/rust/kernel/pci.rs
@@ -238,8 +238,8 @@ pub trait Driver: Send {
 
     /// PCI driver probe.
     ///
-    /// Called when a new platform device is added or discovered.
-    /// Implementers should attempt to initialize the device here.
+    /// Called when a new pci device is added or discovered. Implementers should
+    /// attempt to initialize the device here.
     fn probe(dev: &Device<device::Core>, id_info: &Self::IdInfo) -> Result<Pin<KBox<Self>>>;
 }
 


