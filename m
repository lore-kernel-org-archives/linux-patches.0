Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD7F303CAF;
	Wed, 10 Dec 2025 07:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352150; cv=none; b=GUwbWIpXSXlPY77+mvK5JXg3bSZh6bvDPzreufff3f1JHC1auk1woKTAcf21xZEPLWs+PanEG1txj1XvDAL3mVgpzVPeg+I0AOolcFdFS3UInmIDh7SMafMX6X9NYHdlnzK3/wvTvhXO7PXfZ+ZnWYT+/eTClkK8ZPLgaY8oLlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352150; c=relaxed/simple;
	bh=zyCuiGlaX/aqZAyM0OKgP4fAUJ6Nf5NS6f5Jh6zH5b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TX24+X89V1s7qC6FCYQiFyxb+9Nq7UzDrzBRBP5OxxedvSs8r45HL3Wt71vpISAX7YrZh+J0HWBkxpeeTuevBYAZHLpI5u8Ry7JvQZD8wubcWX8S+hNfYMVsuB6E9nVmh8kToJyaNlqzdCgUNzuervaa7TU3X1B176Tb4lxx3hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ungv+BE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ungv+BE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D035C4CEF1;
	Wed, 10 Dec 2025 07:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352150;
	bh=zyCuiGlaX/aqZAyM0OKgP4fAUJ6Nf5NS6f5Jh6zH5b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ungv+BE1cECO0qB9snioRiz4nPNQszE0x+ONU7ARIEKk77JoLypReXBHhW58XKFTE
	 lgb528ZjW2rVJ5L4iw0UdqEEzTWsm8d9FCXgmC7GnVAb0ql9fYLniMG5Om7NHR4sju
	 fqKsA5wMYhWb+gjVr2T7Zqgdz7nn/w9kVqekVZ/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.18 01/29] Documentation: process: Also mention Sasha Levin as stable tree maintainer
Date: Wed, 10 Dec 2025 16:30:11 +0900
Message-ID: <20251210072944.408116499@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bagas Sanjaya <bagasdotme@gmail.com>

commit ba2457109d5b47a90fe565b39524f7225fc23e60 upstream.

Sasha has also maintaining stable branch in conjunction with Greg
since cb5d21946d2a2f ("MAINTAINERS: Add Sasha as a stable branch
maintainer"). Mention him in 2.Process.rst.

Cc: stable@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20251022034336.22839-1-bagasdotme@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/2.Process.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/process/2.Process.rst
+++ b/Documentation/process/2.Process.rst
@@ -104,8 +104,10 @@ kernels go out with a handful of known r
 of them are serious.
 
 Once a stable release is made, its ongoing maintenance is passed off to the
-"stable team," currently Greg Kroah-Hartman. The stable team will release
-occasional updates to the stable release using the 5.x.y numbering scheme.
+"stable team," currently consists of Greg Kroah-Hartman and Sasha Levin. The
+stable team will release occasional updates to the stable release using the
+5.x.y numbering scheme.
+
 To be considered for an update release, a patch must (1) fix a significant
 bug, and (2) already be merged into the mainline for the next development
 kernel. Kernels will typically receive stable updates for a little more


