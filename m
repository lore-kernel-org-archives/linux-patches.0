Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F5530C160;
	Fri,  4 Sep 2026 05:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498410; cv=none; b=ZciJcc+L+Jo+S2WZbbw0u12DHv4ye1LxYfY/uYrWuXTufAcnX/qqpWkK1Tp4weH6f4d9IOCz6XQXHu49S24owG71+YQ07SNnm2S8sLp4bHoAZbHry+cksfb9JXyrKSdvzWF8UxST4IvOtaM2otuVrCv703WVRBawOY0kjAgneJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498410; c=relaxed/simple;
	bh=NfSVB0F8xB9Lt91ODXvgKxsMtAbWQr9BliCZWVq64YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxctQst2iQ09+yVdiPncx074BgjSeRjpmkBGd0bEx4AKHCGs9vpb6kJCimnewqmS0bTJk4qvjbnYW8o7H+1cmUY5n5+5+hbqcPwFUbKjDSbd8A+NhDucU7QFxZpraE40i7ocDcPWay14wDs9N+oDXJD9pPMEkbcTsgFLpZazHMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9e66o65; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9e66o65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6F61F00A3D;
	Fri,  4 Sep 2026 05:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498408;
	bh=CDASvQv0LPm0O4N6/ctjah8krM08wdrXL8LYUfw6x4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9e66o65iVlTHlyqC8QQhxClXOb7YrZh2qrvnyLsmgueKiGV/zL55ASbLcFmlXIPg
	 QOM8hPgsdHWpGrNqAu0RtMEtb20kAKzknwz+V7TK8Dcu4vTmKYPX/lQin9cMF88QaJ
	 TWvYcynpuDJ/Uiqu8wO1pGmPU4PXONeM/WLcFAB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolai Grlica <nikolai@nikolaigrlica.dev>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 035/713] rust: kernel: list: fix incorrect pop_back example comment
Date: Fri,  4 Sep 2026 06:50:03 +0200
Message-ID: <20260904045804.617301470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolai Grlica <nikolai@nikolaigrlica.dev>

commit a5c7d35e2fd3e24c411816c91f8f6cc78e652e0c upstream.

The example uses pop_back(), but the accompanying comment says
pop_front(). Update the comment to match the example.

Signed-off-by: Nikolai Grlica <nikolai@nikolaigrlica.dev>
Cc: stable@vger.kernel.org
Fixes: bf87a41b85d6 ("rust: list: Add an example for `ListLinksSelfPtr` usage")
Link: https://patch.msgid.link/20260810150322.61809-1-nikolai@nikolaigrlica.dev
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/list.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/list.rs
+++ b/rust/kernel/list.rs
@@ -249,7 +249,7 @@ pub use self::arc_field::{
 ///     assert_eq!(list.iter().count(), 3);
 /// }
 ///
-/// // Pop the items from the list using `pop_front()` and verify the content.
+/// // Pop the items from the list using `pop_back()` and verify the content.
 /// {
 ///     assert_eq!(list.pop_back().ok_or(EINVAL)?.value.foo(), ("a", 15));
 ///     assert_eq!(list.pop_back().ok_or(EINVAL)?.value.foo(), ("a", 32));


