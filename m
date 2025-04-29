Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C572512D7;
	Tue, 29 Apr 2025 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946011; cv=none; b=Q5/j4qPkUAjtC8n0Blxf3rQph6n5rqwISBkIoZbWGwSUprpxqR9TF8v8Qk+lcxrU2qZ5l43eExcQd5ozLEzNHlbVqQq0wdJpoaMEiuZ/r398LxpPxEdyh8z28XKRoKX6bnBIkeB+MOGlDgmstV27DfNPR9tzHeS7Kp9rDQnKnro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946011; c=relaxed/simple;
	bh=K/Jec2skrkmTTEL3HIo1YJFEmm4w1kds96FRJZqKZLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LtZ7hgZn4S619wyxEKRROzRBvb4vIVSTOTGfp3rHKwvfopUQvDk2H2F4op5hBRxeKiG96dnxHfzAo5TTlutxFe6Qct3jJAr78veKGPz5aapaSjK5Sb+qqJBQunKbNe9jOv+VCPyqbPEIREkrLhu25mA+GRUV0/waf1YfPvL7CWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSyo6QWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSyo6QWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22856C4CEE3;
	Tue, 29 Apr 2025 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946011;
	bh=K/Jec2skrkmTTEL3HIo1YJFEmm4w1kds96FRJZqKZLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSyo6QWj9LN7jzCw6gvgw0/OJCRLQsLxBhOkl12/UU8JZ5Nrsg0bBOTSqdDU8Dflp
	 NPz/wQz5tcIKRZIFFIavxzDUzS8yIEtHpd7EBTJQjZSFOibqRLPchVE+RjN242RBCx
	 SKX8fo/i3VwHDi2fk3ecbxLrgq4EzfIXcxixdXww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.14 125/311] selftests/pcie_bwctrl: Fix test progs list
Date: Tue, 29 Apr 2025 18:39:22 +0200
Message-ID: <20250429161126.155908260@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 39e703ed3b48c4262be141072d4f42a8b89a10cc upstream.

Commit df6f8c4d72ae ("selftests/pcie_bwctrl: Add 'set_pcie_speed.sh' to
TEST_PROGS") added set_pcie_speed.sh into TEST_PROGS but that script is a
helper that is only being called by set_pcie_cooling_state.sh, not a test
case itself. When set_pcie_speed.sh is in TEST_PROGS, selftest harness will
execute also it leading to bwctrl selftest errors:

  # selftests: pcie_bwctrl: set_pcie_speed.sh
  # cat: /cur_state: No such file or directory
  not ok 2 selftests: pcie_bwctrl: set_pcie_speed.sh # exit=1

Place set_pcie_speed.sh into TEST_FILES instead to have it included into
installed test files but not execute it from the test harness.

Fixes: df6f8c4d72ae ("selftests/pcie_bwctrl: Add 'set_pcie_speed.sh' to TEST_PROGS")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250417124529.11391-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/pcie_bwctrl/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/pcie_bwctrl/Makefile
+++ b/tools/testing/selftests/pcie_bwctrl/Makefile
@@ -1,2 +1,3 @@
-TEST_PROGS = set_pcie_cooling_state.sh set_pcie_speed.sh
+TEST_PROGS = set_pcie_cooling_state.sh
+TEST_FILES = set_pcie_speed.sh
 include ../lib.mk


