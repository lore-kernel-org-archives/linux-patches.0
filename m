Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB5E13DBA0;
	Mon, 16 Sep 2024 12:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488111; cv=none; b=b1VA1E9gPGQxb9OSePvrYy/bIMMB7Jtom8kMlsoFBmNLsK2yBiswxRetcYHZLJzYAV5iUKWz+4RGX19vbk3ya8knmciplTTzy/UjTxotj+1F2yqZSYrupR2vr0r5tKXyKrd61OKKpQzjcQ3b7uS3dYzLLg6E7tEVPF1Tf2sV2sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488111; c=relaxed/simple;
	bh=TYziCbN38CdEwmDmr+GFCiMlgP02MBU4Py/NqPlCW7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3Kp9JXoOSIPDa2JwkM8z6pLXR8iiE3qPiolIz74RTZ5vgDxdLhIh2dkEoLyNZXYrZOSW03XtL8TSdlNNttukAI11a4WCOPSauuA4KS/b04avDj2nvo0RGDyqM8EYXzQgS8gpBJ0L4QFvbUPdzr1mrOCmesO+bg9wcbs0TK2wKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3Vl6uG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3Vl6uG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A815C4CEC4;
	Mon, 16 Sep 2024 12:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488110;
	bh=TYziCbN38CdEwmDmr+GFCiMlgP02MBU4Py/NqPlCW7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3Vl6uG6JKScq8BZSkhLDJV9VYkrhp+94YJVhB38NlL0Pe4xfaVSEMUmOh30kaT0q
	 ZYq9WdQCVeD/kbny4i1iBiOa13DvyJdkKj85z2QizMuy+MkFkQ/WCVG8B66/A+3By0
	 Sey4UtmZz6cMUY7H7hd5APhpPg6pKT4UP00mkPgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 62/63] pinctrl: meteorlake: Add Arrow Lake-H/U ACPI ID
Date: Mon, 16 Sep 2024 13:44:41 +0200
Message-ID: <20240916114223.229102205@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit a366e46da10d7bfa1a52c3bd31f342a3d0e8e7fe upstream.

Intel Arrow Lake-H/U has the same GPIO hardware than Meteor Lake-P but
the ACPI ID is different. Add this new ACPI ID to the list of supported
devices.

Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/intel/pinctrl-meteorlake.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pinctrl/intel/pinctrl-meteorlake.c
+++ b/drivers/pinctrl/intel/pinctrl-meteorlake.c
@@ -395,6 +395,7 @@ static const struct intel_pinctrl_soc_da
 };
 
 static const struct acpi_device_id mtl_pinctrl_acpi_match[] = {
+	{ "INTC105E", (kernel_ulong_t)&mtlp_soc_data },
 	{ "INTC1083", (kernel_ulong_t)&mtlp_soc_data },
 	{ }
 };


