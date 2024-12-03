Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6051F130F;
	Tue,  3 Dec 2024 15:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239497; cv=none; b=PCM3x1r6GOBSLEG0hZiVeYxOEfQoRFNpH7TxnQn7TbSVr9W8OdHilhInzASsMJMk3Dn+gzwhuA5EtZfhGM+O9T92Vm8MqA9KnxRCP9H3qCN+C/ftODCZWgAct5Xililf2hT8SQJlVajNPqR31nfLolk0y4S0J7OljuM6bo7W1Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239497; c=relaxed/simple;
	bh=pCjMaHpeKfI8fJQdlrdzzoVNRolK4/RncLTAhOhDYCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqkMx7bnQrkR+tE5d60XhQnK5MSKLz50voM4BZFK2UhyvQTzqpXVO6sG0p+VgHf8daTCIItAnClUSWMgMo00JLnhw1BnnzP0aoK/liyZnBpLVL0CXja4N0VI7TIjGqk5nzBh1YXTlhm4bodp7/beJblZrw3RrOW6ocsF6/Cf2T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCGQ1HVp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCGQ1HVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3DAC4CECF;
	Tue,  3 Dec 2024 15:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239497;
	bh=pCjMaHpeKfI8fJQdlrdzzoVNRolK4/RncLTAhOhDYCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCGQ1HVp3OAF5d18Apr4U0bj+KjYNAI+ebVHjZw3C8LSOBTgyBWlzuTyUVoFBnUqb
	 elR5wKOc8mqDYw7fY+DaHEIwUpFXOpTBBkugSGHh6dIoe7sbY4UuGV8eWSpcsHxBiM
	 6AzLiwDRMekOACpbkTCjetggbODkDCr0qvwUZGcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 634/817] ASoC: Intel: sst: Fix used of uninitialized ctx to log an error
Date: Tue,  3 Dec 2024 15:43:26 +0100
Message-ID: <20241203144020.684193114@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit c1895ba181e560144601fafe46aeedbafdf4dbc4 upstream.

Fix the new "LPE0F28" code path using the uninitialized ctx variable
to log an error.

Fixes: 6668610b4d8c ("ASoC: Intel: sst: Support LPE0F28 ACPI HID")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410261106.EBx49ssy-lkp@intel.com/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241026143615.171821-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/atom/sst/sst_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/atom/sst/sst_acpi.c
+++ b/sound/soc/intel/atom/sst/sst_acpi.c
@@ -308,7 +308,7 @@ static int sst_acpi_probe(struct platfor
 		rsrc = platform_get_resource(pdev, IORESOURCE_MEM,
 					     pdata->res_info->acpi_lpe_res_index);
 		if (!rsrc) {
-			dev_err(ctx->dev, "Invalid SHIM base\n");
+			dev_err(dev, "Invalid SHIM base\n");
 			return -EIO;
 		}
 		rsrc->start -= pdata->res_info->shim_offset;


